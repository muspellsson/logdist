:- module(help_viewer,
	  [help_viewer/1, help_frame/1]).
:- use_module(library(pce)).
:- encoding(utf8).

help_frame(V) :-
    new(F, frame('Помощь')),
    send(F, append(new(V, view))),
    send(V, editable, @off),
    send(F, open).

help_viewer(T) :-
    help_frame(V),
    help_file(T, F),
    send(V, load, F),
    send(V, editable, @off).

help_file(mixture, F) :- F = 'help/mixture.txt'.
