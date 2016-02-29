:- module(ask_vocab,
	[ask_vocab/1]).
:- use_module(library(pce)).
:- encoding(utf8).

ask_vocab(BB) :-
	new(D, dialog('Справочник')),
	send(D, append, new(D1, dialog_group(buttons, group))),
	send(D1, label, 'Теплоотдача пар-металл'),
	send(D1, border, size(10, 10)),
	send(D1, append, new(B1, browser)),
	send(D, append, new(D2, dialog_group(buttons, group)), right),
	send(D2, label, 'Теплоотдача металл-жидкость'),
	send(D2, border, size(10, 10)),
	send(D2, append, new(B2, browser)),
	send(D, append, new(D3, dialog_group(buttons, group)), right),
	send(D3, label, 'Теплопроводность металла'),
	send(D3, border, size(10, 10)),
	send(D3, append, new(B3, browser)),
	%send(D, append, new(D4, dialog_group(buttons, group)), below),
	send(D, append, new(N1, text_item('surface')), below),
	send(N1, label, 'Площадь куба, м²:'),
	send(D, append, button(ok)),
	send(D, open).