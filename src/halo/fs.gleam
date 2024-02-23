import gleam/erlang/atom
import gleam/erlang/process

pub type LinkError

pub type SubscribeResult

@external(erlang, "fs", "start_link")
pub fn start_link(watcher: atom.Atom) -> Result(process.Pid, LinkError)

@external(erlang, "fs", "subscribe")
pub fn subscribe(watcher: atom.Atom) -> SubscribeResult
