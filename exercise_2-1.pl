% Insert an element at the proper place of a list. Element, Input, Output
% If the element is smaller than the first element of the list
insertProperPlace(E, [C|I], O):-
    C>=E,
    append([E], [C|I], O).

% If it is not then we need to remove another element and try again.
insertProperPlace(E, List, []):-
    length(List, 0).

insertProperPlace(E, [C|I], O):-
    C<E,
    insertProperPlace(E, I, P),
    append([C], P, O).


isort(Input, []):-
    length(Input, 0).

isort([F|I], O):-
    %length(C, 1), append(C, D, I), % Remove first element
    sort(I, S), % Sort the list %TODO try with isort
    insertProperPlace(F, S, O). % insert the first element


% Is it working ?
partition(Threshold, List, [], []) :-
    length(List, 0).

partition(Threshold, [FirstElement|List], Smaller, [FirstElement|Greater]):-
    Threshold<FirstElement,
    %append([FirstElement], Greater, [FirstElement|Greater]),
    partition(Threshold, List, Smaller, Greater).

partition(Threshold, [FirstElement|List], [FirstElement|Smaller], Greater):-
        Threshold>=FirstElement,
        %append([FirstElement], Smaller, [FirstElement|Smaller]),
        partition(Threshold, List, Smaller, Greater).


qsort(Input, []) :-
            length(Input, 0).

qsort(Input, O):-
    random_select(Element, Input, Rest),
    partition(Element, Rest, Smaller, Greater),
    qsort(Smaller, SmallerSorted),
    qsort(Greater, GreaterSorted),
    append(SmallerSorted, [Element|GreaterSorted], O).
