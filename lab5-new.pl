container(a, 2, 2).
container(b, 4, 1).
container(c, 2, 2).
container(d, 1, 1).
container(e, 2, 2).
container(f, 4, 1).
container(g, 2, 2).
container(h, 1, 1).

on(a, d).
on(b, c).
on(c, d).
on(e, a).
on(f, e).
on(f, b).
on(g, f).
on(h, g).

blegah([], [], []).
blegah([container(N, W, D)|Tail], [task(S, D, E, W, N)|Ts], [S|Rs]):-
	E #= S + D,
	blegah(Tail, Ts, Rs).

containers_start(Tasks, Ss):-
	findall(container(A,B,C), container(A,B,C), Containers),
	blegah(Containers, Tasks, Ss).

total_workers([], 0).
total_workers([task(_, _, _, W, _) | CTail], R):-
	total_workers(CTail, N),
	R is N+W.

sum_durations([], 0).
sum_durations([task(_, D, _, _, _) | CTail], R):-
	sum_durations(CTail, N),
	R is N+D.

minimize_total_time([], _).
minimize_total_time([task(ST, D, _, _, _) | CTail], TD):-
	TD #>= ST + D,
	minimize_total_time(CTail, TD).


find_task([task(S1, D1, _, _, N1) | _], N1, task(S1, D1, _, _, N1)).
find_task([task(_, _, _, _, _N1) | CTail], N, X):-
	find_task(CTail, N, X).

respect_order(_, []).
respect_order(Containers, [on(N1, N2) | OTail]):-
	find_task(Containers, N1, task(ST1, D1, _, _, N1)),
	find_task(Containers, N2, task(ST2, _, _, _, N2)),
	ST2 #>= ST1+D1,
	respect_order(Containers, OTail).


limit_workers([], _).
limit_workers([task(_, _, _, R, _) | CTail], MaxWorkers):-
	MaxWorkers #>= R,
	limit_workers(CTail, MaxWorkers).

work(Cost):-
	containers_start(Containers, Vars),

	% Get domain for each duration.
	% Calculate worst case scenario by summing all durations
	sum_durations(Containers, D),
	Vars ins 0..D,

	% Get domain for number of workers 
	total_workers(Containers, W),
	MaxWorkers in 1..W,

	% Restrain TD
	TD in 0..D,
	minimize_total_time(Containers, TD),

	% Restrain MaxWorkers
	limit_workers(Containers, MaxWorkers),

	findall(on(A,B), on(A,B), Ons),
	respect_order(Containers, Ons),

	% Get max_duration
	Cost #= TD * MaxWorkers,

	% to guarantee optimality we should have the following line:
	% cumulative(Containers, [limit(MaxWorkers)]), 
	% But this doesn't work in swi-prolog, so instead we use:
   	cumulative(Containers, [limit(W)]), 
   	% Only works on swi-prolog
   	labeling([min(Cost)], [Cost| Vars]).
   	


% Examples:
% container(a, 2, 2).
% container(b, 4, 1).
% container(c, 2, 2).
% container(d, 1, 1).

% on(a, d).
% on(b, c).
% on(c, d).
% ?- work(Cost).
% Cost = 16 .

% container(a, 2, 2).
% container(b, 4, 1).
% container(c, 2, 2).
% container(d, 1, 1).
% container(e, 2, 2).
% container(f, 4, 1).
% container(g, 2, 2).
% container(h, 1, 1).

% on(a, d).
% on(b, c).
% on(c, d).
% on(e, a).
% on(f, e).
% on(f, b).
% on(g, f).
% on(h, g).

% ?- work(Cost).
% Cost = 36 
