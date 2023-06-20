import gleam/dynamic
import gleam/erlang/atom
import gleam/erlang/process
import gleam/erlang/file
import gleam/io
import gleam/list
import gleam/string
import gleam/result
import halo/code
import halo/fs
import halo/modres
import halo/shell
import shellout

type Notification {
  Notification(path: String, events: List(Event))
}

type Event {
  Created
  Modified
  Removed
  Renamed
  Undefined
}

external fn decode_event(
  event: dynamic.Dynamic,
) -> Result(Event, List(dynamic.DecodeError)) =
  "halo_erl" "decode_event"

pub fn main() {
  let fswatcher = atom.create_from_string("fswatcher")
  let assert Ok(_pid) = fs.start_link(fswatcher)
  fs.subscribe(fswatcher)

  update_path()

  let assert shell.Ok = shell.start()

  watch_loop()
}

pub fn update_path() {
  let _ = {
    let build_dir = "build/dev/erlang/"
    use modules <- result.map(file.list_directory(build_dir))
    modules
    |> list.filter_map(fn(module) {
      case file.is_directory(build_dir <> module) {
        Ok(True) -> Ok(build_dir <> module <> "/ebin")
        _ -> Error(Nil)
      }
    })
    |> code.add_paths
  }
  Nil
}

fn watch_loop() {
  let notif = receive()

  update_path()

  case string.ends_with(notif.path, ".gleam") {
    True -> {
      case shellout.command(run: "gleam", in: ".", with: ["build"], opt: []) {
        Ok(_) -> {
          let modified = code.modified_modules()
          case list.length(modified) {
            0 -> Nil
            _ -> {
              case code.soft_purge_all(modified) {
                Ok(Nil) -> {
                  let assert modres.Ok = code.atomic_load(modified)
                  io.println("REPL: reload.")
                }
                Error(mod) ->
                  io.println(
                    "REPL: could not purge module " <> code.module_name(mod) <> ", please clean up processes running old code.",
                  )
              }
            }
          }
        }
        Error(_) -> io.println("REPL: compilation failed, no reload.")
      }
    }
    False -> Nil
  }

  watch_loop()
}

fn receive() -> Notification {
  let notif = {
    process.new_selector()
    |> process.selecting_anything(fn(msg) {
      let msg =
        msg
        |> dynamic.tuple3(
          dynamic.dynamic,
          dynamic.dynamic,
          fn(payload) {
            payload
            |> dynamic.tuple2(
              dynamic.list(dynamic.int),
              dynamic.list(decode_event),
            )
          },
        )

      use #(_, _, #(path, events)) <- result.try(msg, _)

      let path =
        path
        |> list.map(fn(i) {
          let assert Ok(c) = string.utf_codepoint(i)
          c
        })
        |> string.from_utf_codepoints

      Ok(Notification(path, events))
    })
    |> process.select_forever()
  }

  case notif {
    Ok(notif) -> notif
    Error(_) -> receive()
  }
}
