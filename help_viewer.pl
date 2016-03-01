:- module(help_viewer,
	  [help_viewer/1, help_frame/1]).
:- use_module(library(pce)).
:- use_module(library(readutil)).
:- encoding(utf8).

help_frame(V) :-
    new(F, frame('Помощь')),
    send(F, append(new(V, view))),
    send(V, editable, @off),
    send(F, open).

help_viewer(T) :-
    help_frame(V),
    help_file(T, F),
    open(F, read, File, [encoding(utf8)]),
    read_stream_to_codes(File, S),
    atom_codes(A, S),
    send(V, append, A),
    send(V, editable, @off).

help_file(mixture, F) :- F = 'help/mixture.txt'.
help_file(vocab, F) :- F = 'help/vocab.txt'.
help_file(binary, F) :- F = 'help/binary.txt'.