import gleam/list
import halo/modres.{Module}
import gleam/erlang/charlist

pub external fn modified_modules() -> List(Module) =
  "code" "modified_modules"

pub external fn atomic_load(List(Module)) -> modres.ModuleResult =
  "code" "atomic_load"

pub external fn soft_purge(Module) -> Bool =
  "code" "soft_purge"

pub external fn module_name(Module) -> String =
  "halo_erl" "module_name"

pub fn soft_purge_all(modules: List(Module)) -> Result(Nil, Module) {
  list.try_each(
    modules,
    fn(mod) {
      case soft_purge(mod) {
        True -> Ok(Nil)
        False -> Error(mod)
      }
    },
  )
}

pub fn add_paths(paths: List(String)) -> modres.ModuleResult {
  let paths =
    paths
    |> list.map(charlist.from_string)
  add_paths_internal(paths)
}

pub external fn add_paths_internal(
  paths: List(charlist.Charlist),
) -> modres.ModuleResult =
  "code" "add_paths"
