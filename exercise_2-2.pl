% middle(X,Xs)
% X is the middle element in the list Xs


middle(X, [X]). % Position is not important when append is befor middle
%if append is after middle -> with this line first you'll get at least one answer, otherwise you'll get the infinitle loop from the beginning

middle(X, [First|Xs]) :-
	append(Middle, [Last], Xs), % The position of this 2 lines is important because we can get infinite loops --> if middle(X,Middle) comes first we get stuck
    middle(X, Middle).
