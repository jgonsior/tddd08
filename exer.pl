%skip
evaluate(InitialMemory, skip, InitialMemory).

%evaluate(InitialMemory, Program, ResultingMemory)
evaluate([],  set(X,Y),  [[X|Y]]).

evaluate([[X|_]|InitialMemory], set(X, Y), [[X|Y]|InitialMemory]).

evaluate([[Z, P]|InitialMemory], set(X, Y), [[Z, P]|OutputMemory]) :-
	Z \= X,
	evaluate(InitialMemory, set(X, Y), OutputMemory).

%if
evaluate(InitialMemory, if(true, Y, Z), OutputMemory) :-
	evaluate(InitialMemory, Y, OutputMemory).

evaluate(InitialMemory, if(false, Y, Z), OutputMemory) :-
	evaluate(InitialMemory, Z, OutputMemory).

%while
evaluate(InitialMemory, while(X, Y), OutputMemory) :-
	evaluate(InitialMemory, if(X,seq(Y,while(X,Y)),skip), OutputMemory).

%seq
evaluate(InitialMemory, seq(X,Y), OutputMemory) :-
	evaluate(InitialMemory, X, OutputMemory2),
	evaluate(OutputMemory2, Y, OutputMemory).
