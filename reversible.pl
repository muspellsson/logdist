:- module(reversible,
	  [separate/4,
	   lowboiling/4, rev_ece/4]).

:- use_module(streams).
:- use_module(library(mavis)).
:- use_module(library(typedef)).

separate(M, I, U, L) :-
	take(M, I, U),
	drop(M, I, L).

rebmem(X, component(Name, _, _, _, _)) :-
	member(component(Name, _, _, _, _), X).

inlower(X, component(Name, Yu, _, _, _)) :-
	member(component(Name, Yl, _, _, _), X),
	Yl < Yu.

inlower(X, component(Name, _, _, _, _)) :-
	\+(member(component(Name, _, _, _, _), X)).

lowboiling(F, U, L, Res) :-
	include(rebmem(F), U, R0),
	include(inlower(L), R0, R1),
	include(rebmem(R1), F, Res).

plusx(component(_, X1, _, _, _), X2, Res) :-
	Res is X1 + X2.

plusrx(component(_, X1, _, R1, _), X2, Res) :-
	Res is X1 * R1 + X2.

% This predicates are for the binary case
key_x1(F, U, L, Res) :-
	lowboiling(F, U, L, R0),
	foldl(plusx, R0, 0, Res).

key_xD(F, U, L, Res) :-
	lowboiling(F, U, L, R0),
	include(rebmem(R0), U, R1),
	foldl(plusx, R1, 0, Res).

key_xB(F, U, L, Res) :-
	lowboiling(F, U, L, R0),
	include(rebmem(R0), L, R1),
	foldl(plusx, R1, 0, Res).

key_r1(F, U, L, Res) :-
	lowboiling(F, U, L, R0),
	foldl(plusrx, R0, 0, R1),
	key_x1(F, U, L, R2),
	Res is R1 / R2.

key_TD1(F, U, L, Res) :-
	lowboiling(F, U, L, R0),
	sort(3, @=<, R0, R1),
	last(R1, component(_, _, Res, _, _)).

key_TB1(F, U, L, Res) :-
	sort(3, @=<, F, R0),
	lowboiling(F, U, L, R1),
	sort(3, @=<, R1, R2),
	last(R2, component(Name, _, _, _, _)),
	nth0(I, R0, component(Name, _, _, _, _)),!,
	plus(I, 1, J),
	nth0(J, R0, component(_, _, Res, _, _)).


eps1(F, U, L, Res) :-
	key_x1(F, U, L, R0),
	key_xD(F, U, L, R1),
	key_xB(F, U, L, R2),
	Res is (R0 - R2) / (R1 - R2).

gibbs1(F, U, L, Res) :-
	key_TD1(F, U, L, R0),
	key_x1(F, U, L, R1),
	key_xD(F, U, L, R2),
	key_xB(F, U, L, R3),
	eps1(F, U, L, R4),
	R5 is -8.31 * R0 * (R1 * log(R1) + (1 - R1) * log(1 - R1)),
	R6 is -8.31 * R0 * R4 * (R2 * log(R2) + (1 - R2) * log(1 - R2)),
	R7 is -8.31 * R0 * (1 - R4) * (R3 * log(R3) + (1 - R3) * log(1 - R3)),
	Res is R5 - R6 - R7.

rev_ece(F, U, L, Res) :-
	key_TD1(F, U, L, R0),
	key_TB1(F, U, L, R1),
	gibbs1(F, U, L, R2),
	Res is (R1 - R0) / (R1 * R2).

