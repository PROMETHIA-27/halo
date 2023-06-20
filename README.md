# halo

A hot-reloading repl for Gleam.

# Installation

## Releases
Download a release off of the releases tab on this github, add it to your path somewhere, and invoke it as `halo`.

## Gleam
run `gleam add halo` and invoke it as `gleam run -m halo`. Must be installed once per project.

## Build from source
Clone the repository, build it, and then use `mote` to package it or otherwise figure out how to invoke it.

# Usage

Invoke the REPL via `halo` in the console, and use it as a normal erl shell. It will automatically search the directory it's invoked in (recursively) for altered gleam files, invoke the gleam compiler (`gleam build`) in its directory, and then reload any modules it sees are changed. If you attempt to reload twice while code is still running from before a reload, you will have to kill that code somehow before it will reload again. If you use fully qualified calls in a loop, (`module:func` instead of `func`) it will jump to the newest loaded version of the function rather than continuing to stay old.

# Disclaimer

It is likely that changing types or the signatures of functions will lead to issues during hot reloading. It won't crash the shell (probably) but your code might all break. This is because gleam's static type system exists only at compile time, and becomes erlang's dynamic type system afterwards. To prevent this, make sure to specify function signatures, avoid changing them, and avoid changing type definitions while hot reloading. That said, it's entirely possible to make such changes in a way that does not break, so don't be afraid to. The worst that will happen is some code running in the shell fails.

# Demo

https://github.com/PROMETHIA-27/halo/assets/42193387/8a831640-f12d-4fa9-b976-85e21e55e650
