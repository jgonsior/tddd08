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
on(d,e).
on(e,f).
on(e,g).

% plan(HiredWorkers,TotalDuration, TotalCost)
plan(HiredWorkers, TotalDuration, Totalcost).

% unload(ListOfContainers, UnloadPlan)
% unload [a,b,c], [[a,b], [c]]
unload([], [[]]).
unload([Container|ContainerList], [[Container|CurrentUnloading]|OtherUnloadings]) :-
	checkIfOtherContainersUnloaded(Container, OtherUnloadings).



calculate(ContainerList,Plan,Price,Workers) :-
	checkPlan(ContainerList, Plan).

% checkPlan(Plan) -> needs to check if all containers from on() are being used
% then needs to check if it is allowed to unload the containers that are in this plan --> the plan contains all the timestamps!
% all container from the first unloading are only those, that have nothing on them
% all container from the second unloading are only those, that have nothing on them or are unloaded in the first round
checkPlan([], _).

checkPlan([OneUnloading|OtherUnloadings], ContainersThatCanBeUsed) :-
	checkIfOtherContainersUnloaded(OneUnloading, ContainersThatCanBeUsed),
	append(OneUnloading, ContainersThatCanBeUsed, ContainersThatCanBeUsedNextTime),
	checkPlan(OtherUnloadings, ContainersThatCanBeUsedNextTime).


% checkIfOtherContainersUnloaded(ContainerList, ContainersThatCanBeUsed)
% checkIfOtherContainersUnloaded([a], [b,c,e).
% so all containers that are on top of a need to be in otherunloadings
%
checkIfOtherContainersUnloaded([Container|ContainerList], UnloadPlan) :-
	onTop(Container, TopContainers),
	sublist(TopContainers, UnloadPlan).

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


% sublist(List1, List2) true if every element from List1 is contained in List2
sublist([], _).
sublist([X|Xs], List2) :-
	member(X, List2),
	sublist(Xs, List2).
