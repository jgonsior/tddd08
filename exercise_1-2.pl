% Descritption of the graph :
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

% Rules
path(X, Y, [Z|P]) :- connection(X, Z), path(Z, Y, P).
path(X, Y, [Y]) :- connection(X, Y).
npath(X, Y, [P, Q]) :- path(X, Y, P), length(P, Q).
