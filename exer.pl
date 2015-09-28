%skip
evaluate(InitialMemory, skip, InitialMemory).

%evaluate(InitialMemory, Program, ResultingMemory)
evaluateSet(OriginalMemory, [],  set(X,Expression),  [[X,Result]]):-
	evaluate_arithmetic_expression(OriginalMemory,Expression, Result).

evaluateSet(OriginalMemory, [[X|Xs]|InitialMemory], set(X, Expression), [[X,Result]|InitialMemory]):-
	evaluate_arithmetic_expression(OriginalMemory, Expression, Result).

evaluateSet(OriginalMemory, [[Z, P]|InitialMemory], set(X, Expression), [[Z, P]|OutputMemory]) :-
	Z \= X,
	evaluateSet(OriginalMemory, InitialMemory, set(X, Expression), OutputMemory).

evaluate(InitialMemory, set(X,Y), OutputMemory) :-
	evaluateSet(InitialMemory, InitialMemory, set(X,Y), OutputMemory).

%if
evaluate(InitialMemory, if(true, Y, Z), OutputMemory) :-
	evaluate(InitialMemory, Y, OutputMemory).

evaluate(InitialMemory, if(false, Y, Z), OutputMemory) :-
	evaluate(InitialMemory, Z, OutputMemory).

evaluate(InitialMemory, if(X, Y, Z), OutputMemory) :-
	evaluate_boolean_expression(InitialMemory, X, XBool),
	evaluate(InitialMemory, if(XBool, Y, Z), OutputMemory).

%TODO while is not working - The rest seems to be fine
evaluate(InitialMemory, while(X, Y), OutputMemory) :-
	evaluate_boolean_expression(InitialMemory, X, true),
	evaluate(InitialMemory, Y, OutputMemory2),
	evaluate(OutputMemory2, while(X,Y), OutputMemory).

evaluate(InitialMemory, while(X, Y), InitialMemory) :-
		evaluate_boolean_expression(InitialMemory, X, false).
%seq
evaluate(InitialMemory, seq(X,Y), OutputMemory) :-
	evaluate(InitialMemory, X, OutputMemory2),
	evaluate(OutputMemory2, Y, OutputMemory).

readFromMemory([[A, Value]|RestOfMemory], A, Value).
readFromMemory([[A, Value]|RestOfMemory], X, Xa):-
	readFromMemory(RestOfMemory, X, Xa).

access(Memory, X, X):-
	number(X).
access(Memory, X, Xa):-
	not(number(X)),
	readFromMemory(Memory, X, Xa).


% If X and Y are numbers :
evaluate_arithmetic_expression(Memory, X, X) :-
		number(X).
evaluate_arithmetic_expression(Memory, X+Y, Z) :-
		access(Memory, X, Xa),
		access(Memory, Y, Ya),
		Z is Xa+Ya.
evaluate_arithmetic_expression(Memory, X-Y, Z) :-
		access(Memory, X, Xa),
		access(Memory, Y, Ya),
		Z is Xa-Ya.
evaluate_arithmetic_expression(Memory, X*Y, Z) :-
		access(Memory, X, Xa),
		access(Memory, Y, Ya),
		Z is Xa*Ya.
evaluate_arithmetic_expression(Memory, X/Y, Z) :-
		access(Memory, X, Xa),
		access(Memory, Y, Ya),
		Z is Xa/Ya.

evaluate_boolean_expression(Memory, X>Y, true) :-
		access(Memory, X, Xa),
		access(Memory, Y, Ya),
		Xa>Ya.

evaluate_boolean_expression(Memory, X>Y, false):-
	access(Memory, X, Xa),
	access(Memory, Y, Ya),
	not(Xa>Ya).

% Test in the lab instructions :
%evaluate([[x,3]], seq(set(id(y),1), while(id(x) > 1, seq(set(id(y), id(y) * id(x)), set(id(x), id(x) - 1)))), Out).
% Without id
%evaluate([[x,3]], seq(set(y,1), while(x > 1, seq(set(y, y * x), set(x, x - 1)))), Out
