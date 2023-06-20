//// Had to move this type to a new module so it didn't collide with `Result`

pub external type Module

pub type ModuleResult {
  Ok
  Error(List(#(Module, What)))
}

pub type What {
  Badfile
  Nofile
  OnLoadNotAllowed
  Duplicated
  NotPurged
  StickyDirectory
  PendingOnLoad
}
