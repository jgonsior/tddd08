


id(X) :-
    string(X).


e(X):-
    id(X).

if(Condition, If, Else) :-
    true(Condition),
    c(If),
    c(Else),
    execute(_,If, Output).


if(Condition, If, Else) :-
    false(Condition),
    c(If),
    c(Else),
    execute(_,Else, Output).

%true(Expression) :-
%    is Expression.

e(X):-
    number(X).

e(X) :-
    +(X,X, Output).

e(X) :-
    -(X,X, Output).

e(X) :-
    *(X,X, Output).

skip.

set(I, E) :-
    id(I),
    number(E).



+(X,Y, Output):-
        set(X, ValX),
        set(Y, ValY),
        Output is ValX+ValY.

*(X,Y, Output):-
        set(X, ValX),
        set(Y, ValY),
        Output is ValX*ValY.

-(X,Y, Output):-
        set(X, ValX),
        set(Y, ValY),
        Output is ValX-ValY.

setAll(A):-
    length(A, 0).

setAll([[FirstIdentifier|[FirstNumber]]|Rest]):-
    set(FirstIdentifier, FirstNumber),
    setAll(Rest).

% execute([[a,4],[b,3],[d,9]])
execute(InitialBinding, Program, FinalBinding):-
    setAll(intialBinding, Bindings).


id(a).
id(b).
set(a,5).
set(b, 7).
