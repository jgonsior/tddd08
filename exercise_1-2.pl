% edges of the graph :
connection(a, b).
connection(a, c).
connection(b, c).
connection(c, d).
connection(d, h).
connection(c, e).
connection(e, f).
connection(d, f).
connection(f, g).
connection(e, g).

% true, if there is a path from node X to node Y, the third argument is the path
path(X, Y, [Z|P]) :- 
	connection(X, Z), 
	path(Z, Y, P).

path(X, Y, [Y]) :- 
	connection(X, Y).

% true if there is a path between node X and node Y, the last argument is the length of the path
npath(X, Y, [P, Q]) :-
	path(X, Y, P), 
	length(P, Q).
