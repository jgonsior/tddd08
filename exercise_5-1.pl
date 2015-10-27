:- use_module(library(clpfd)).

% container(B,M,D) Container B needs M persons to be unloaded, and the unloading takes D amount of time
%container(10,2,2).
container(20,4,1).
container(30,2,2).
container(40,1,1).

% on(A,B) container A is on B
%on(10,40).
on(20,30).
on(30,40).
%on(d,e).
%on(e,f).
%on(e,g).

% returns a list of tasks and a list of start times
tasks_starts_ends(Tasks, Starts, Ends) :-
	%list of containers
	findall([Time, Persons,Container], container(Container, Persons, Time), Cons),
	length(Cons, ContainerCount),
	%list of start time
	length(Starts, ContainerCount),
	%list of end times
	length(Ends, ContainerCount),

	%create tasks
	create_tasks(Cons, Starts, Ends, Tasks).

%create_tasks(Containers, StartTime, EndTimes, ResultingTaskList)
%add a new clpfd task() to the resulting list
create_tasks([],[],[],[]).
create_tasks([[Time, Persons, Container]|Cons], [Start|Starts], [End|Ends], [task(Start, Time, End, Persons, Container)|Tasks]) :-
	create_tasks(Cons, Starts, Ends, Tasks).

run(Tasks, Starts, Ends, End) :- 
	tasks_starts_ends(Tasks, Starts, Ends),
	domain(Starts, 1, 300),
	domain(Ends, 1, 500),
	domain([End], 1,500),
	restrictEndTimesAccordingToDuration(Tasks),
	restrictTasks(Tasks, Tasks),
	maximum(End, Ends),
	cumulative(Tasks, [limit(150)]),
	append(Starts, [End], Vars),
	labeling([minimize(End)], Vars).

% add constraint for EndTime = StartTime + Duration of Task
restrictEndTimesAccordingToDuration([]).
restrictEndTimesAccordingToDuration([task(Start,Time,End,_,_)|Tasks]) :-
	End #= Start+Time,
	restrictEndTimesAccordingToDuration(Tasks).


% restrict the start times w.r.t. to the on top constraint
restrictTasks([],_).
restrictTasks([task(Start, Time, End, _, Container)|Tasks], OriginalTasks) :-
	%start time of this task needs to be before end time of containers on which this one task is on top
	onTop(Container, TopContainers),
	getStartTimes(TopContainers, StartTimes, OriginalTasks),
	restrictEndTime(End, StartTimes),
	restrictTasks(Tasks, OriginalTasks).

%returns a list of the startTimes for the containers from the first argument
getStartTimes([],[],_).
getStartTimes([Container|TopContainers], StartTimes, OriginalTasks) :-
	%find Container in OriginalTasks
	getStartTime(Container, Start, OriginalTasks),
	getStartTimes(TopContainers, StartTimes2, OriginalTasks),
	append([Start], StartTimes2, StartTimes).


%returns the end time for one container
getStartTime(Container, Start, [task(Start,_,_,_,Container) | OriginalTasks]).
getStartTime(Container, Start, [task(Start,_,_,_,AnotherContainer)|OriginalTasks]) :-
	Container \= AnotherContainer,
	getStartTime(Container, Start, OriginalTasks).

restrictEndTime(End, []).
restrictEndTime(End, [StartTime|StartTimes]) :-
	End #< StartTime,
	restrictEndTime(End, StartTimes).


% returns a list of Containers that are on top of a Container
onTop(Container, []) :-
	%if there is no container on top of it
	\+ on(_,Container).

onTop(Container, TopContainers) :-
	on(_,Container), % bug: matches multiple times -> the same result is being returned twice or more times
	findall(X, on(X,Container), TopContainers1),
	%transitivity -> call onTop again for all containers from TopContainers1
	onTop2(TopContainers1, TopContainers2),
	append(TopContainers1, TopContainers2, TopContainers).

% transitivity help function
onTop2([], []).
onTop2([Container|TopContainerRest], Result) :-
	onTop(Container, Result2),
	onTop2(TopContainerRest, Result3),
	append(Result2, Result3, Result).
