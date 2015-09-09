% Info 1
woman(ulrika).
beautiful(ulrika).

% Info 2
beautiful(nisse).
rich(nisse).
man(nisse).

% Info 3
rich(bettan).
strong(bettan).
woman(bettan).

% Info 4
strong(peter).
man(peter).
beautiful(peter).

% Info 5
kind(bosse).
strong(bosse).
man(bosse).

% Rule 6
like(X, Y) :- man(X), woman(Y), beautiful(Y).

% Rule 10
like(nisse, Y) :- woman(Y), like(Y, nisse).

% Rule 11
like(ulrika, Y) :- man(Y), rich(Y), kind(Y).
like(ulrika, Y) :- man(Y), beautiful(Y), strong(Y).

% Rule 7
happy(X) :- rich(X).

% Rule 8
happy(X) :- man(X), like(X, Y), like(Y, X), woman(Y).

% Rule 9
happy(X) :- woman(X), like(X, Y), like(Y, X), man(Y).
