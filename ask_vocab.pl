:- module(ask_vocab,
	[ask_vocab/1]).
:- use_module(library(pce)).
:- use_module(library(readutil)).
:- encoding(utf8).

ask_vocab(BB) :-
	new(D, dialog('Справочник')),
	send(D, append, new(DD, dialog_group(buttons, group))),
	send(DD, append, new(D1, dialog_group(buttons, group))),
	send(D1, label, 'Теплоотдача пар-металл'),
	send(D1, border, size(10, 10)),
	send(D1, append, new(B1, browser)),
	send(DD, append, new(D2, dialog_group(buttons, group)), right),
	send(D2, label, 'Теплоотдача металл-жидкость'),
	send(D2, border, size(10, 10)),
	send(D2, append, new(B2, browser)),
	send(DD, append, new(D3, dialog_group(buttons, group)), right),
	send(D3, label, 'Теплопроводность металла'),
	send(D3, border, size(10, 10)),
	send(D3, append, new(B3, browser)),
	send(D, append, new(N1, text_item('surface')), below),
	send(N1, label, 'Площадь куба, м²:'),
	send(D, append, button(ok, message(@prolog, ret, D, 
		B1, B2, B3, N1?selection))),
	fill_browser(1, B1),
	fill_browser(2, B2),
	fill_browser(3, B3),
	send(D, default_button, ok),
	get(D, confirm, Answer),
	send(D, destroy),
	Answer \== @nil,
	BB = Answer.

ret(D, B1, B2, B3, N1) :-
	(
		get(B1, selection, Sel1),
		get(B2, selection, Sel2),
		get(B3, selection, Sel3)
	) -> 
	(
		(
			get(Sel1, key, S1), get(Sel2, key, S2), get(Sel3, key, S3),
			calculate(S1, S2, S3, N1, Res)
		) -> send(D, return, Res);
		send(D, return, @nil)
	);
	send(D, return, @nil).

calculate(S1, S2, S3, S4, Res) :-
	split_string(S1, "\t", " ", L1),
	split_string(S2, "\t", " ", L2),
	split_string(S3, "\t", " ", L3),
	last(L1, La1),
	last(L2, La2),
	last(L3, La3),
	number_string(No1, La1),
	number_string(No2, La2),
	number_string(No3, La3),
	number_string(No4, S4),
	Res = No1.	

fill_browser(1, B) :-
	open('vocab/vocab1.txt', read, F),
	do_fill(F, B).

fill_browser(2, B) :-
	open('vocab/vocab2.txt', read, F),
	do_fill(F, B).

fill_browser(3, B) :-
	open('vocab/vocab3.txt', read, F),
	do_fill(F, B).

do_fill(F, B) :-
	read_line_to_codes(F, S),
	(
		S = end_of_file -> !;
		atom_codes(A, S),
		send(B, append, A),
		do_fill(F, B)
	).