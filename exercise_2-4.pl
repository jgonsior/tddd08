%Union is the union of the setlists A and B
union(A, B, Union):-
    append(A,B,UnionList),
    sort(UnionList, Union). % To remove the duplicates

% intersectionsLists(A,B,C)
% C is the intersection of the two setlists A and B
intersectionLists([], B, []).

intersectionLists([A|As], B, [A|Intersection]):-
    member(A, B),
	delete(B,A,Bnew),
    intersectionLists(As, Bnew, Intersection).

intersectionLists([A|As], [X|Y], Intersection):-
	not(member(A, [X|Y])),
    intersectionLists(As, [X|Y], Intersection).

%sortList(A,B) sorts A into B
sortList([], []).
sortList([A|As], B) :- 
	sort([A|As], B).

sortList(A, [A]).

% like intersectionsLists, but without duplicates
intersection(A, B, Intersection):-
    intersectionLists(A, B, Output),
    sort(Output, Intersection). % Remove duplicate elements

% true if A is a subset of B
subset(A,B):-
    intersection(A, B, A).

% Powerset is a list of all subsets from A
powerset(A, Powerset):-
    findall(Subset, subset(Subset, A), Powerset).
