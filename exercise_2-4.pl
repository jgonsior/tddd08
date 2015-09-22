union(A, B, Union):-
    append(A,B,UnionList),
    sort(UnionList, Union). % To remove the duplicates

intersectionLists([], B, []).
intersectionLists(A, [], []).
intersectionLists([], [], []).

intersectionLists([A|As], B, [A|Intersection]):-
    member(A, B),
    intersectionLists(As, B, Intersection).

intersectionLists([A|As], B, Intersection):-
    not(member(A, B)),
    intersectionLists(As, B, Intersection).

sortList([], []).
sortList([A|As], B):-sort([A|As], B).
sortList(A, [A]).

intersection(A, B, Intersection):-
    %sortList(A, ASorted),
    %sort(B, BSorted),
    intersectionLists(A, B, Output),
    sort(Output, Intersection). % Remove duplicate elements

subset(A,B):-
    intersection(A, B, A).

powerset(A, Powerset):-
    findall(Subset, subset(Subset, A), Powerset).
