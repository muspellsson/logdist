:- module(streams, [take/3, drop/3]).

take_([], _, _, Acc, Res) :-
	reverse(Acc, Res), !.
take_(_, I, I, Acc, Res) :-
	reverse(Acc, Res), !.
take_([_ | T], I, C, Acc, Res) :-
	C >= I,
	C1 is C + 1,
	take_(T, I, C1, Acc, Res), !.
take_([H | T], I, C, Acc, Res) :-
        C < I,
	C1 is C + 1,
	take_(T, I, C1, [H | Acc], Res).

take(L, I, Res) :-
	take_(L, I, 0, [], Res).

drop_([], _, _, Acc, Res) :-
	reverse(Acc, Res), !.
drop_([_ | T], I, C, Acc, Res) :-
	C < I,
	C1 is C + 1,
	drop_(T, I, C1, Acc, Res),!.
drop_([H | T], I, C, Acc, Res) :-
	C >= I,
	C1 is C + 1,
	drop_(T, I, C1, [H | Acc], Res).


drop(L, I, Res) :-
	drop_(L, I, 0, [], Res).
