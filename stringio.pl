:- module(stringio,
	  [string_component/2,
	   component_string/2,
	   string_mixture/2,
	   mixture_string/2]).

string_component(component(Name, X, T, R, Alpha), Res) :-
	number_string(X, Xs),
	number_string(T, Ts),
	number_string(R, Rs),
	number_string(Alpha, As),
	string_concat(Name, "; ", R0),
	string_concat(R0, Xs, R1),
	string_concat(R1, "; ", R2),
	string_concat(R2, Ts, R3),
	string_concat(R3, "; ", R4),
	string_concat(R4, Rs, R5),
	string_concat(R5, "; ", R6),
	string_concat(R6, As, Res).

component_string(Str, component(Name, X, T, R, Alpha)) :-
	split_string(Str, ";", " ", [Name, R0, R1, R2, R3]),
	number_string(X, R0),
	number_string(T, R1),
	number_string(R, R2),
	number_string(Alpha, R3).

string_mixture([], "").
string_mixture([C], Res) :-
	string_component(C, Res), !.
string_mixture([H | T], Res) :-
	string_mixture(T, R0),
	string_component(H, R1),
	string_concat(R1, "\n", R2),
	string_concat(R2, R0, Res).

mixture_string("", []).
mixture_string(Str, Res) :-
	split_string(Str, "\n", " ", R0),
	maplist(component_string, R0, Res).
