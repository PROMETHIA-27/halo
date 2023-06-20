-module(halo_erl).

-export([decode_event/1, is_atom/2, module_name/1]).

decode_event(X) when 
    (X == created) or 
    (X == modified) or
    (X == removed) or 
    (X == renamed) or 
    (X == undefined) -> {ok, X};
decode_event(X) -> {error, [{decode_error, <<"Event">>, gleam_stdlib:classify_dynamic(X), []}]}.

is_atom(Atom, Name) when is_atom(Atom) -> 
    AtomName = atom_to_binary(Atom),
    AtomName == Name;
is_atom(_, _) -> false.

module_name(Mod) -> atom_to_binary(Mod).