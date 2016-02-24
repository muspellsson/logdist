:- use_module(library(pce)).
:- use_module(library(help_message)).
:- use_module(ask_mixture).

:- encoding(utf8).

main :-
    new(F, dialog('Бинарная ректификация')),
    new(M, var),
    new(C, chain),
    send(M, assign, C),
    send(F, append, button('исходная_смесь', message(@prolog, get_feed, M))),
    send(F, open).

get_feed(M) :-
    send(@prolog, =, M0, M),
    chain_list(M0, M1),
    ask_mixture(M2, M1),
    chain_list(M3, M2),
    send(M, assign, M3).
    
