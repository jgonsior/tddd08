% middle(X,Xs)
% X is the middle element in the list Xs
middle(X, [First|Xs]) :-
    append(Middle, [Last], Xs), % The position of this 2 lines is important because we can get infinite loops 
    middle(X, Middle).
middle(X, [X]). % Position is not important
