% parser

:-include('scanner.pl').
:-include('exercise_2-3.pl').

%DCG according to lab instructions
pgm(X) --> cmd(X).
pgm(seq(A,B)) --> cmd(A), [;], pgm(B).

cmd(skip) --> [skip].
cmd(set(A,B)) --> ident(A) , [:=], expr(B).
cmd(if(A,B,C)) --> [if], bool(A), [then], pgm(B), [else], pgm(C), [fi].
cmd(while(A,B)) --> [while], bool(A), [do], pgm(B), [od].

bool(A > B) --> expr(A), [>], expr(B).
bool(A >=  B) --> expr(A), [>=], expr(B).
bool(A < B) --> expr(A), [<], expr(B).
bool(A =< B) --> expr(A), [=<], expr(B). % ATTENTION! =< and >= :-)
bool(A = B) --> expr(A), [=], expr(B).
bool(A) --> expr(A).

expr(A * B) --> factor(A), [*], expr(B).
expr(A) --> factor(A).

factor(A + B) --> term(A), [+], factor(B).
factor(A) --> term(A).

term(X) --> ident(X).
term(X) --> numb(X).

ident(id(X)) --> [id(X)], {atom(X)}.
numb(num(X)) --> [num(X)], {number(X)}.



run(In, String, Out) :-
	scan(String, Tokens),
	parse(Tokens, AbstStx),
	evaluate(In, AbstStx, Out).

parse(Tokens,AbstStx) :-
	pgm(AbstStx,Tokens, []).


/* run it with:
run([[id(x),num(3)]],
"y:=1; z:=0; while x>z do z:=z+1; y:=y*z od",
Res).

*/
