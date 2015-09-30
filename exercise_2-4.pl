union(A, B, Union):-
    append(A,B,UnionList),
    sort(UnionList, Union). % To remove the duplicates

intersectionLists([], B, []).

intersectionLists([A|As], B, [A|Intersection]):-
    member(A, B),
	delete(B,A,Bnew),
    intersectionLists(As, Bnew, Intersection).

intersectionLists([A|As], [X|Y], Intersection):-
	not(member(A, [X|Y])),
    intersectionLists(As, [X|Y], Intersection).

sortList([], []).
sortList([A|As], B):-sort([A|As], B).
sortList(A, [A]).

intersection(A, B, Intersection):-
    intersectionLists(A, B, Output),
    sort(Output, Intersection). % Remove duplicate elements

subset(A,B):-
    intersection(A, B, A).

powerset(A, Powerset):-
    findall(Subset, subset(Subset, A), Powerset).
