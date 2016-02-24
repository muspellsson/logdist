:- module(ask_mixture,
	  [ask_mixture/2]).
:- use_module(library(pce)).
:- use_module(library(help_message)).
:- use_module(help_viewer).
:- use_module(stringio).
:- encoding(utf8).

ask_mixture(M, M1) :-
	new(D, dialog('Редактор компонентов')),
	send(D, append, new(B, browser)),
	send(B, attribute, hor_stretch, 100),
	maplist(store(B), M1),
	send_list(D, append,
		  [ new(N1, text_item('наименование')),
		    new(N2, text_item('мольная_доля')),
		    new(N3, text_item('температура_кипения')),
		    new(N4, text_item('теплота_парообразования')),
		    new(N5, text_item('летучесть'))]),
	send(N1, label, 'Наименование:'),
	send(N2, label, 'x:'),
	send(N2, help_message, tag, 'Мольная доля, моль/моль'),
	send(N3, label, 'T, К:'),
	send(N3, help_message, tag, 'Температура кипения'),
	send(N4, label, 'r, кДж/моль'),
	send(N4, help_message, tag, 'Мольная теплота парообразования'),
	send(N5, label, 'α'),
	send(N5, help_message, tag, 'Относительная летучесть'),
	send_list(D, append,
		  [ button('добавить', message(@prolog, add,
					    N1?selection,
					    N2?selection,
					    N3?selection,
					    N4?selection,
					    N5?selection, B)),
		    button('сохранить', message(@prolog, save,
					     N1?selection,
					     N2?selection,
					     N3?selection,
					     N4?selection,
					     N5?selection, B)),
		    button('удалить', message(@prolog, delete, B)),
		    button('очистить', message(B, clear))]),
	send(D, append, button(ok, message(@prolog, ret, D, B?members)), below),
	send(D, append, button('отмена', message(D, return, @nil)), right),
	send(D, append, button('помощь',
			       message(@prolog, help_viewer, mixture)), right),
	send(D, default_button, 'сохранить'),
	get(D, confirm, Answer),
	send(D, destroy),
	Answer \== @nil,
	M = Answer.

store(B, E) :-
    string_component(E, S),
    send(B, append, S).

ret(D, B) :-
    get(B, map, @arg1?key, S),
    chain_list(S, L),
    maplist(component_string, L, L1),
    send(D, return, L1).

add(Name, X, T, R, A, B) :-
	atom_number(X, X1),
	atom_number(T, T1),
	atom_number(R, R1),
	atom_number(A, A1),
	store(B, component(Name, X1, T1, R1, A1)).

save(Name, X, T, R, A, B) :-
	\+(get(B, selection, _)),
	add(Name, X, T, R, A, B).

save(Name, X, T, R, A, B) :-
	atom_number(X, X1),
	atom_number(T, T1),
	atom_number(R, R1),
	atom_number(A, A1),
	get(B, selection, I),
	string_component(component(Name, X1, T1, R1, A1), S),
	send(I, key, S),
	send(I, label, S).

delete(B) :-
	get(B, selection, I),
	send(B, delete, I).
























