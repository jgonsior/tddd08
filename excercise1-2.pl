% path(X,Y,Z)
% if there is a path from X to Y then it is the path Z
path(X,Y,[X,Y]) :-
	edge(X,Y).

path(X,Y,[X,Z,Y,P]) :-
	edge(X,Z),
	path(Z,Y,[Z,P]).

% facts
edge(a,b).
edge(a,c).
edge(b,c).
edge(c,e).
edge(c,d).
edge(d,h).
edge(d,f).
edge(e,f).
edge(e,g).
edge(f,g).
