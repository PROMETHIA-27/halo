pub type ShellResult {
  Ok
  Error(AlreadyStarted)
}

pub type AlreadyStarted {
  AlreadyStarted
}

@external(erlang, "shell", "start_interactive")
pub fn start() -> ShellResult
