% parser

:-include('scanner.pl').
:-include('exercise_2-3.pl').

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
id --> [X], {string(X)}.
num --> [X], {number(X)}.

%id --> [a].
%id --> [b].
%id --> [c].
%id --> [d].
%num --> [0].
%num --> [1].
%num --> [2].
%num --> [3].
%num --> [4].
%num --> [5].


run(In, String, Out) :-
	scan(String, Tokens),
	parse(Tokens, AbstStx),
	evaluate(In, AbstStx, Out).


parse(Tokens, AbstStx).
