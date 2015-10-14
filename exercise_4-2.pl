cannibal(a).
cannibal(b).
cannibal(c).
missionary(d).
missionary(e).
missionary(f).

initialState(a, b, c, d, e, f).

getListCannibals([],[]).

getListCannibals([FirstElement | RestOfList], Cannibals):-
    cannibal(FirstElement),
    getListCannibals(RestOfList, TmpCannibals),
    append(TmpCannibals, [FirstElement], Cannibals).

getListCannibals([FirstElement | RestOfList], Cannibals):-
    not(cannibal(FirstElement)),
    getListCannibals(RestOfList, Cannibals).

getListMissionaries([], []).

getListMissionaries([FirstElement | RestOfList], Missionaries):-
    missionary(FirstElement),
    getListMissionaries(RestOfList, TmpMissionaries),
    append(TmpMissionaries, [FirstElement], Missionaries).

getListMissionaries([FirstElement | RestOfList], Missionaries):-
    not(missionary(FirstElement)),
    getListMissionaries(RestOfList, Missionaries).

% True if there are no missionary
possibleState(State):-
    getListCannibals(State, Cannibals),
    getListMissionaries(State, Missionaries),
    length(Missionaries, 0).

% True if there are less cannibals than missionaries
possibleState(State):-
    getListCannibals(State, Cannibals),
    getListMissionaries(State, Missionaries),
    length(Cannibals, LengthCannibals),
    length(Missionaries, LengthMissionaries),
    LengthCannibals =< LengthMissionaries.

% Does a list contain an element ?
contains([Element|Tail], Element).

contains([Head|Tail], Element):-
    contains(Tail, Element).

% Transport two element from on side to another.
transport(Departure, Arrival, FirstElement, SecondElement, NewDeparture, [FirstElement, SecondElement | Arrival]):-
    contains(Departure, FirstElement),
    contains(Departure, SecondElement),
    delete(Departure, FirstElement, TmpDeparture),
    delete(TmpDeparture, SecondElement, NewDeparture),
    possibleState(NewDeparture),
    possibleState([FirstElement, SecondElement | Arrival]).

% It is finished if there is no one else on the first bank of the river.
findTravels([], Arrival, Travels, Travels).

findTravels(Departure, Arrival, PreviousTravels, TravelsOut):-
    transport(Departure, Arrival, X, Y, NewDeparture, NewArrival),
    append(Travels, [X, Y], NewTravels),
    %TODO Check if this travel is not a loop - i.e. if it does not put us in a state we have already been in
    transport(NewArrival, NewDeparture, A, B, NewArrival2, NewDeparture2),
    %TODO Again, check for a loop
    append(NewTravels, [A,B], NewTravelsReturn),
    findTravels(NewDeparture2, NewArrival2, NewTravelsReturn, TravelsOut).
