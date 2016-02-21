:- module(mixture_editor,
	  [mixture_editor/0]).
:- use_module(library(pce)).
:- use_module(stringio).

mixture_editor :-
	new(Main, frame('Редактор компонентов')),
	send(Main, append(new(B, browser))),
	send(new(D, dialog), below(B)),
	send_list(D, append,
		  [ new(N1, text_item(название)),
		    new(N2, text_item(концентрация)),
		    new(N3, text_item(температура_кипения)),
		    new(N4, text_item(теплота_парообразования)),
		    new(N5, text_item(летучесть)),
		    button(добавить, message(@prolog, add,
					    N1?selection,
					    N2?selection,
					    N3?selection,
					    N4?selection,
					    N5?selection, B)),
		    button(сохранить, message(@prolog, save,
					     N1?selection,
					     N2?selection,
					     N3?selection,
					     N4?selection,
					     N5?selection, B)),
		    button(удалить, message(@prolog, delete, B)),
		    button(очистить, message(B, clear))]),
	send(Main, open).

add(Name, X, T, R, A, B) :-
	atom_number(X, X1),
	atom_number(T, T1),
	atom_number(R, R1),
	atom_number(A, A1),
	string_component(component(Name, X1, T1, R1, A1), S),
	send(B, append, S).

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






