% i need one predicate that lists all possible ways to unload the containers
%
:- use_module(library(clpfd)).

% container(B,M,D) Container B needs M persons to be unloaded, and the unloading takes D amount of time
container(a,2,2).
container(b,4,1).
container(c,2,2).
container(d,1,1).

% on(A,B) container A is on B
on(a,d).
on(b,c).
on(c,d).
%on(d,e).
%on(e,f).
%on(e,g).
% it is possible to unload A -> works only if there is no other container on it
unload(a).

% plan(HiredWorkers,TotalDuration, TotalCost)
plan(HiredWorkers, TotalDuration, Totalcost).

% unload(ListOfContainers, UnloadPlan)
% unload [a,b,c], [[a,b], [c]]
unload([], [[]]).
unload([Container|ContainerList], [[Container|CurrentUnloading]|OtherUnloadings]) :-
	checkIfOtherContainersUnloaded(Container, OtherUnloadings).

% checkIfOtherContainersUnloaded(Container, OtherUnloadings)
% checkIfOtherContainersUnloaded(a, [[b,c],[e]).
% so all containers that are on top of a need to be in otherunloadings
%
checkIfOtherContainersUnloaded(Container, UnloadPlan) :-
	onTop(Container, TopContainers),
	contained(TopContainers, UnloadPlan).

checkIfOtherContainersUnloaded(Container, [FirstList|OtherUnloadings]) :-
	checkIfOtherContainersUnloaded(Container, OtherUnloadings).

% contained(ContainerList, UnloadPlan) 
% checks if every Container from ContainerList is contained in the UnloadPlan
contained([],_).
contained([Container|ContainerListRest], [Unloading|UnloadPlanRest]) :-
	member(Container, Unloading),
	contained(ContainerListRest, [Unloading|UnloadPlanRest]).

contained([Container|ContainerListRest], [Unloading|UnloadPlanRest]) :-
	contained([Container], UnloadPlanRest),
	contained(ContainerListRest, [Unloading|UnloadPlanRest]).







%BUG -> result is being returned twice!
% onTop(Container, OnTopContainerList) -> lists all containers that are on top of this container
onTop(Container, []) :-
	%if there is no container on top of it
	not(on(Container, _)).

onTop(Container, TopContainers) :-
	findall(X, on(Container, X), TopContainers1),
	%transitivity -> call onTop again for all containers from TopContainers1
	onTop2(TopContainers1, TopContainers2),
	append(TopContainers1, TopContainers2, TopContainers).

onTop2([], []).
onTop2([Container|TopContainerRest], Result) :-
	onTop(Container,Result).














