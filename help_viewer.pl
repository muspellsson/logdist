:- module(help_viewer,
	  [help_viewer/1, help_frame/1]).
:- use_module(library(pce)).
:- encoding(utf8).

help_frame(V) :-
    new(F, frame('Помощь')),
    send(F, append(new(V, view))),
    send(V, editable, @off),
    send(F, open).

help_viewer(mixture) :-
    help_frame(V),
    send(V, load, file('help1.txt')),
    send(V, editable, @off).
