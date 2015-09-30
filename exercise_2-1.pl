% Insert an element at the proper place of a list. Element, Input, Output
% If the element is smaller than the first element of the list
insertProperPlace(E, [C|I], [E,C|I]):-
    C>=E.

% If it is not then we need to remove another element and try again.
insertProperPlace(E, [], [E]).

insertProperPlace(E, [C|I], [C|P]):-
    C<E,
    insertProperPlace(E, I, P).


isort([], []).

isort([F|I], O):-
    isort(I, S), % Sort the lis
    insertProperPlace(F, S, O). % insert the first element


% Is it working ?
partition(Threshold, [], [], []).

partition(Threshold, [FirstElement|List], Smaller, [FirstElement|Greater]):-
    Threshold<FirstElement,
    partition(Threshold, List, Smaller, Greater).

partition(Threshold, [FirstElement|List], [FirstElement|Smaller], Greater):-
        Threshold>=FirstElement,
        partition(Threshold, List, Smaller, Greater).


qsort([], []).

qsort(Input, O):-
    random_select(Element, Input, Rest),
    partition(Element, Rest, Smaller, Greater),
    qsort(Smaller, SmallerSorted),
    qsort(Greater, GreaterSorted),
    append(SmallerSorted, [Element|GreaterSorted], O).
