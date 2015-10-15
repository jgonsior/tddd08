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

tasks_starts2(Tasks, [S1,S2,S3,S4]) :-
	Tasks = [task(S1, 2, _, 2,a),
	         task(S2, 1, _, 4, b),
	         task(S3, 2, _, 2, c),
	         task(S4, 1, _, 1, d)].
tasks_starts(Tasks) :-
	findall(task(_,Time, _, Persons,Container), container(Container, Persons, Time), Tasks).	


% seems not to work!
get_a_start(Tasks, S) :-
	member(task(S,_,_,_,_), Tasks).

get_starts(Tasks, Starts) :-
	findall(S, get_a_start(Tasks,S), Statrs).


goaly(Tasks, Starts, Limit) :- 
	tasks_starts(Tasks),
	checkPlan(Tasks),
	%get_starts(Tasks, Starts),
	Starts ins 0..100, % Starts #> 3.
	[Limit] ins 1..100,
	once(labeling([max(Limit)],[Limit])),
	cumulative(Tasks, [limit(Limit)]),
	label(Starts).

checkPlan([]).
checkPlan([Task|Tasks]) :-
	checkIfOtherContainersUnloaded(Task, Tasks),
	checkPlan(Tasks).

% checkIfOtherContainersUnloaded(Task, Tasks)
% needs to check, if at the timeStamp at which this one container wants to be unloaded all other container that are on top of him are already unloaded

checkIfOtherContainersUnloaded(task(Time,_,_,_,Container), Tasks) :-
	onTop(Container, TopContainers),
	unloadedContainers(Tasks, Time-1, UnloadedContainers),
	sublist(TopContainers, UnloadedContainers).


% UnloadedContainers is a list of the container ids that are unloaded at the timestamp Time
unloadedContainers(Tasks, Time, UnloadedContainers) :-
	findall(Container, unloaded(Tasks, Container, Time), UnloadedContainers).

unloaded([task(_, _, Endtime, _,Container)| Tasks], Container, Timestamp) :-
	Timestamp >=Endtime .

unloaded([task(_, _, Endtime, _,_)| Tasks], Container, Timestamp) :-
	unloaded(Tasks, Container, Timestamp).


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


% checkPlan(Plan) -> needs to check if all containers from on() are being used
% then needs to check if it is allowed to unload the containers that are in this plan --> the plan contains all the timestamps!
% all container from the first unloading are only those, that have nothing on them
% all container from the second unloading are only those, that have nothing on them or are unloaded in the first round
checkPlan([], _).

checkPlan([OneUnloading|OtherUnloadings], ContainersThatCanBeUsed) :-
	checkIfOtherContainersUnloaded(OneUnloading, ContainersThatCanBeUsed),
	append(OneUnloading, ContainersThatCanBeUsed, ContainersThatCanBeUsedNextTime),
	checkPlan(OtherUnloadings, ContainersThatCanBeUsedNextTime).

