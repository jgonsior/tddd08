:- use_module(library(clpfd)).

container(a, 2, 2).
container(b, 4, 1).
container(c, 2, 2).
container(d, 1, 1).

on(a, d).
on(b, c).
on(c, d).

tasks([task(S1, D1, _, _, N1) | _], N1, task(S1, D1, _, _, N1)).
tasks([task(_, _, _, _, _N1) | Tasks], N, X):-
	tasks(Tasks, N, X).

%find all tasks
tasks_starts_end(Tasks, StartTimes):-
	findall(container(Container,Persons,Time), container(Container,Persons,Time), Containers),
	restrictEndTimesAccordingToDuration(Containers, Tasks, StartTimes).

run(Cost):-
	tasks_starts_end(Containers, StartTimes),
	countTime(Containers, TotalTime),
	StartTimes ins 0..TotalTime,
	countWorkers(Containers, TotalWorkers),
	MaxWorkers in 1..TotalWorkers,
	End in 0..TotalTime,
	restrictEndTime(Containers, End),
	restrictWorkers(Containers, MaxWorkers),

	findall(on(A,B), on(A,B), TopContainers),
	restrictStartTimes(Containers, TopContainers),

	% calculate cost! 
	Cost #= End * MaxWorkers,
   	cumulative(Containers, [limit(TotalWorkers)]), 
   	labeling([min(Cost)], [Cost| StartTimes]).


%add constraint for EndTime = StartTime + Duration of Task
restrictEndTimesAccordingToDuration([], [], []).
restrictEndTimesAccordingToDuration([container(N, W, Time)|OtherContainers], [task(Start, Time, End, W, N)|Tasks], [Start|StartTimes]):-
	End #= Start+Time,
	restrictEndTimesAccordingToDuration(OtherContainers, Tasks, StartTimes).

restrictEndTime([], _).
restrictEndTime([task(Start, Time, _, _, _) | Tasks], End):-
	End #>= Start + Time,
	restrictEndTime(Tasks, End).


countWorkers([], 0).
countWorkers([task(_, _, _, Persons, _) | Tasks], TotalWorkers):-
	countWorkers(Tasks, N),
	TotalWorkers is N+Persons.

countTime([], 0).
countTime([task(_, Time, _, _, _) | Tasks], TotalTime):-
	countTime(Tasks, N),
	TotalTime is N+Time.

restrictStartTimes(_, []).
restrictStartTimes(Containers, [on(Container1, Container2) | TopContainers]):-
	tasks(Containers, Container1, task(Start1, Time1, _, _, Container1)),
	tasks(Containers, Container2, task(Start2, _, _, _, Container2)),
	Start2 #>= Start1+Time1,
	restrictStartTimes(Containers, TopContainers).


restrictWorkers([], _).
restrictWorkers([task(_, _, _, Persons, _) | Tasks], MaxWorkers):-
	MaxWorkers #>= Persons,
	restrictWorkers(Tasks, MaxWorkers).
