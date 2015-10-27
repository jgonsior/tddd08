% Insert an element at the proper place of a list. Element, Input, Output
% If the element is smaller than the first element of the list
insertProperPlace(E, [C|I], [E,C|I]):-
    C>=E.

% If it is not then we need to remove another element and try again.
insertProperPlace(E, [], [E]).

insertProperPlace(E, [C|I], [C|P]):-
    C<E,
    insertProperPlace(E, I, P).

%isort(X,Y)
%Y is the sortey lits X, sortey with insertion sort
isort([], []).

isort([F|I], O):-
    isort(I, S), % Sort the lis
    insertProperPlace(F, S, O). % insert the first element


% partition(Threshold, X,Y,Z)
% partition the list X into a list with all elements smaller than Thershold (Y) and a list with greater elements(Z)
partition(Threshold, [], [], []).

partition(Threshold, [FirstElement|List], Smaller, [FirstElement|Greater]):-
    Threshold<FirstElement,
    partition(Threshold, List, Smaller, Greater).

partition(Threshold, [FirstElement|List], [FirstElement|Smaller], Greater):-
        Threshold>=FirstElement,
        partition(Threshold, List, Smaller, Greater).

%qsort(X,Y) sorts X accordings to quicksort
qsort([], []).

qsort(Input, O):-
    random_select(Element, Input, Rest),
    partition(Element, Rest, Smaller, Greater),
    qsort(Smaller, SmallerSorted),
    qsort(Greater, GreaterSorted),
    append(SmallerSorted, [Element|GreaterSorted], O).
