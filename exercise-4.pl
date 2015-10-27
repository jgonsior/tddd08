% Core algorithm

% Initial and final state.
initial((3,3, go, 0,0)).
final((0,0, return, 3,3)).

% 1 or 2 persons at a time in the boat.
can_move(2,0).
can_move(1,0).
can_move(1,1).
can_move(0,2).
can_move(0,1).

% Change the direction - the sign is : do we add or remove people from the first side (opposite for the second side)
changeDirection(go, return, -1).
changeDirection(return, go, 1).

% Valid states
valid_state(NumberMissionaries, NumberCannibals):-
    NumberMissionaries >= NumberCannibals,
    0 < NumberMissionaries,
    0 < NumberCannibals.
valid_state(0, NumberCannibals):-NumberCannibals>=0.
valid_state(NumberMissionaries, 0):-0<NumberMissionaries.

move((MissionariesFirstSideInitial,CannibalsFirstSideInitial, DirectionInitial, MissionariesSecondSideInitial,CannibalsSecondSideInitial),
    (MissionariesFirstSideNew, CannibalsFirstSideNew, DirectionNew, MissionariesSecondSideNew,CannibalsSecondSideNew)) :-

    % Change the direction and get the sign (add or remove people from the first side)
    changeDirection(DirectionInitial, DirectionNew, Sign),

    % Is this possible in the boat ?
    can_move(MoveMissionaries, MoveCannibals),

    % Proceed
    MissionariesFirstSideNew is MissionariesFirstSideInitial + MoveMissionaries * Sign,
    CannibalsFirstSideNew is CannibalsFirstSideInitial + MoveCannibals * Sign,
    % The sign is the opposite for the second side
    MissionariesSecondSideNew is MissionariesSecondSideInitial + MoveMissionaries * Sign * -1,
    CannibalsSecondSideNew is CannibalsSecondSideInitial + MoveCannibals * Sign * -1,

    % Is this a valide state ?
    valid_state(MissionariesFirstSideNew, CannibalsFirstSideNew),
    valid_state(MissionariesSecondSideNew, CannibalsSecondSideNew).


%%%% Search methods
printpath([]).
printpath([Head | Tail]):-
    writeln(Head),
    printpath(Tail).

% Starting point - call me to solve with dfs !
solve_with_dfs :-
    initial(InitialState),
    dfs(InitialState, [InitialState], Path),
    printpath(Path).

% Finished - reverse the list to print it
dfs(S, RPath, Path) :-
    final(S),
    reverse(RPath, Path).

dfs(S, Path, FinalPath) :-
    move(S, T), % Try a new move
    not(member(T, Path)), % Avoid any loops
    dfs(T, [T|Path], FinalPath). % Continue until it fails / succeeds

% Starting point - call me to solve with bfs !
solve_with_bfs :-
    initial(InitialState),
    bfs2([[InitialState]], Path),
    printpath(Path).

bfs2(Paths, Path) :-
    extend(Paths, Extended),
    member(ReversePath, Extended),
    ReversePath = [H|_],
    final(H),
    reverse(ReversePath, Path).

bfs2(Paths, Path) :-
    extend(Paths, Extended),
    bfs2(Extended, Path).

% From all the paths at a certain level n, find all the possibles moves to a level level n+1
extend(Paths, Extended) :-
    findall([NewState,ActualState|R],
        (   member([ActualState|R], Paths), % Get all the states at a level n
            move(ActualState, NewState), % Get all possible moves
            not((member(NewState, R))) % Add it only once
        ), Extended),
    Extended \= []. % Not empty
