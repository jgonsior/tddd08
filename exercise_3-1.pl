% parser
pgm --> cmd.
pgm --> cmd, [;], pgm.

cmd --> [skip].
cmd --> id , [:=], expr.
cmd --> [if], bool, [then], pgm, [else], pgm, [fi].
bool --> expr, [>], expr.
expr --> factor, [*], expr.
expr --> factor.
factor --> term, [+], factor.
factor --> term.
term --> id.
term --> num.

id(X, Y) :-
	string(X).

num(X, Y) :-
	number(X).
