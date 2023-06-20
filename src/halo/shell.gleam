pub type ShellResult {
  Ok
  Error(AlreadyStarted)
}

pub type AlreadyStarted {
  AlreadyStarted
}

pub external fn start() -> ShellResult =
  "shell" "start_interactive"
