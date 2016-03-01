:- use_module(library(pce)).
:- use_module(library(help_message)).
:- use_module(ask_mixture).
:- use_module(ask_vocab).
:- use_module(help_viewer).

:- encoding(utf8).

:- pce_begin_class(binwin, dialog, "Main window").

variable(mfeed, string, get, "Feed mixture").
variable(mupper, string, get, "Upper product mixture").
variable(mlower, string, get, "Lower product mixture").

initialise(D) :->
	send_super(D, initialise('Бинарная ректификация')),
	send(D, clearvars),
	send(D, menus),
	send(D, mixture_group),
	send(D, betad_group),
	send(D, betab_group),
	send(D, k_group),
	send(D, append, button('расчет')),
	send(D, append, button('помощь', 
		message(@prolog, help_viewer, binary)), right),
	send_super(D, open).

clearvars(D) :->
	send(D, slot, mfeed, ""),
	send(D, slot, mupper, ""),
	send(D, slot, mlower, "").

menus(D) :->
	send(D, append, new(M, menu_bar)),
	send(M, append, new(Fm, popup('файл'))),
	send(M, append, new(Ft, popup('инструменты'))),
	send(Fm, append, new(Mo, menu_item('открыть'))),
	send(Mo, accelerator, 'Ctrl-O').

mixture_group(D) :->
	new(D1, dialog_group(buttons, group)),
	send(D1, label, 'Компоненты'),
	send(D1, border, size(10, 10)),
	send(D1, size, size(400, 40)),
	send(D1, elevation, 1),
	new(B1, button('исходная_смесь')),
	new(B2, button('верхний_продукт')),
	new(B3, button('нижний_продукт')),
	send(B1, message, message(D, get_feed, B1, mfeed)),
	send(B2, message, message(D, get_feed, B2, mupper)),
	send(B3, message, message(D, get_feed, B3, mlower)),
	send(D1, append, B1),
	send(D1, append, B2, right),
	send(D1, append, B3, right),
	send(B1, help_message, tag, 'Пусто'),
	send(B2, help_message, tag, 'Пусто'),
	send(B3, help_message, tag, 'Пусто'),
	send(D, append, D1).

betad_group(D) :->
	new(D1, dialog_group(buttons, group)),
	send(D1, label, 'Коэффициент теплопереноса в дефлегматоре, кВт/К'),
	send(D1, border, size(10, 10)),
	send(D1, size, size(400, 80)),
	send(D1, elevation, 1),
	new(C, text_item('bD')),
	send(C, label, 'βᴰ:'),
	send(D1, append, C),
	send(D1, append, button('по_справочнику', message(D, vocab, C))),
	send(D1, append, button('по_известным_параметрам'), right),
	send(D, append, D1).

betab_group(D) :->
	new(D1, dialog_group(buttons, group)),
	send(D1, label, 'Коэффициент теплопереноса в кубе, кВт/К'),
	send(D1, border, size(10, 10)),
	send(D1, size, size(400, 80)),
	send(D1, elevation, 1),
	new(C, text_item('bB')),
	send(C, label, 'βᴮ:'),
	send(D1, append, C),
	send(D1, append, button('по_справочнику', message(D, vocab, C))),
	send(D1, append, button('по_известным_параметрам'), right),
	send(D, append, D1).

vocab(D, C) :->
	ask_vocab(Coeff),
	send(C, selection, Coeff).

k_group(D) :->
	new(D1, dialog_group(buttons, group)),
	send(D1, label, 'Коэффициент массопереноса'),
	send(D1, border, size(10, 10)),
	send(D1, size, size(400, 100)),
	send(D1, elevation, 1),
	new(C, text_item('k')),
	send(C, label, 'k:'),
	send(D1, append, C),
	send(D1, append, button('по_формуле')),
	send(D1, append, button('по_одному_режиму'), right),
	send(D1, append, button('по_двум_режимам'), below),
	send(D1, append, button('по_трем_и_более_режимам'), right),
	send(D, append, D1).


get_feed(D, B, Var) :->
	get(D, Var, F),
	get(F, value, F0),
	atom_string(F0, F1),
	send(@prolog, ask_mixture, M, F1),
	send(B, help_message, tag, M),
	send(D, slot, Var, M).

:- pce_end_class.