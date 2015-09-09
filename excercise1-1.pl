% clauses:

% like(X,Y)
% person X likes person Y
like(X,Y) :-
	men(X), 
	women(Y), 
	beautiful(Y).

like(ulrika, X) :-
	men(X),
	rich(X),
	kind(X),
	like(X, ulrika).

like(ulrika, X) :-
	men(X),
	beautiful(X),
	strong(X),
	like(X, ulrika).

like(nisse, Y) :-
	women(Y),
	like(Y, nisse).

% happy(X)
% X is a happy person
happy(X) :- 
	rich(X).

happy(X) :-
	men(X), 
	like(X, Y),
	women(Y),
	like(Y, X).

happy(Y) :-
	men(X),
	like(X,Y),
	women(Y),
	like(Y,X).

%facts
% women(X)
% person X is a women
women(ulrika).
women(bettan).

% men(X)
% person X is a men
men(nisse).
men(peter).
men(bosse).

% beautiful(X)
% person X is beautiful
beautiful(ulrika).
beautiful(nisse).
beautiful(peter).

% rich(X)
% person X is rich
rich(nisse).
rich(bettan).

% strong(X)
% person X is strong
strong(bettan).
strong(peter).
strong(bosse).

% kind(X)
% person X is 
kind(bosse).


% goals:
% Who is happy? -> happy(X).
% Who likes who? -> like(A,B).
% How many persons like Ulrika? -> findall(X, like(ulrika, X), Xs), length(Xs, P).
