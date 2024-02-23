import gleam/list
import halo/modres.{type Module}
import gleam/erlang/charlist

@external(erlang, "code", "modified_modules")
pub fn modified_modules() -> List(Module)

@external(erlang, "code", "atomic_load")
pub fn atomic_load(module_lst: List(Module)) -> modres.ModuleResult

@external(erlang, "code", "soft_purge")
pub fn soft_purge(module: Module) -> Bool

@external(erlang, "halo_erl", "module_name")
pub fn module_name(module: Module) -> String

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

@external(erlang, "code", "add_paths")
pub fn add_paths_internal(
  paths: List(charlist.Charlist),
) -> modres.ModuleResult
