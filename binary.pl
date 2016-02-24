:- use_module(library(pce)).
:- use_module(library(help_message)).
:- use_module(ask_mixture).

:- encoding(utf8).

:- pce_begin_class(binwin, dialog, "Main window").

variable(mfeed, string, get, "Feed mixture").
variable(mupper, string, get, "Upper product mixture").
variable(mlower, string, get, "Lower product mixture").

initialise(D) :->
	  send_super(D, initialise('Бинарная ректификация')),
          send(D, slot, mfeed, ""),
          send(D, slot, mupper, ""),
	  send(D, slot, mlower, ""),
          new(B1, button('исходная_смесь')),
	  new(B2, button('верхний_продукт')),
	  new(B3, button('нижний_продукт')),
	  send(B1, message, message(D, get_feed, B1, mfeed)),
	  send(B2, message, message(D, get_feed, B2, mupper)),
	  send(B3, message, message(D, get_feed, B3, mlower)),
          send(D, append, B1),
	  send(D, append, B2, right),
	  send(D, append, B3, right),
	  send(B1, help_message, tag, 'Пусто'),
	  send(B2, help_message, tag, 'Пусто'),
	  send(B3, help_message, tag, 'Пусто'),
          send_super(D, open).

get_feed(D, B, Var) :->
	get(D, Var, F),
        get(F, value, F0),
        atom_string(F0, F1),
        send(@prolog, ask_mixture, M, F1),
	send(B, help_message, tag, M),
        send(D, slot, Var, M).

get_upper(D, B) :->
	get(D, mupper, F),
        get(F, value, F0),
        atom_string(F0, F1),
        send(@prolog, ask_mixture, M, F1),
	send(B, help_message, tag, M),
        send(D, slot, mupper, M).

get_lower(D, B) :->
	get(D, mlower, F),
        get(F, value, F0),
        atom_string(F0, F1),
        send(@prolog, ask_mixture, M, F1),
	send(B, help_message, tag, M),
        send(D, slot, mlower, M).


:- pce_end_class.
