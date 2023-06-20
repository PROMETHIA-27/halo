import gleam/erlang/atom
import gleam/erlang/process

pub external type LinkError

pub external type SubscribeResult

pub external fn start_link(watcher: atom.Atom) -> Result(process.Pid, LinkError) =
  "fs" "start_link"

pub external fn subscribe(watcher: atom.Atom) -> SubscribeResult =
  "fs" "subscribe"
