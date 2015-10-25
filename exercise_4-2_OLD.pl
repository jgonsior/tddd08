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
    not(length(Missionaries, 0)),
    LengthCannibals =< LengthMissionaries.

% Does a list contain an element ?
contains([Element|Tail], Element).

contains([Head|Tail], Element):-
    contains(Tail, Element).

% Transport two elements from one side to another.
transport(Departure, Arrival, FirstElement, SecondElement, NewDeparture, [FirstElement, SecondElement | Arrival]):-
    contains(Departure, FirstElement),
    delete(Departure, FirstElement, TmpDeparture),
    contains(TmpDeparture, SecondElement),
    delete(TmpDeparture, SecondElement, NewDeparture),
    possibleState(NewDeparture),
    possibleState([FirstElement, SecondElement | Arrival]).

% Transport just one person
transport(Departure, Arrival, FirstElement, SecondElement, NewDeparture, [FirstElement | Arrival]):-
    contains(Departure, FirstElement),
    delete(Departure, FirstElement, NewDeparture),
    SecondElement="Nobody",
    possibleState(NewDeparture),
    possibleState([FirstElement | Arrival]).

% It is finished if there is no one else on the first bank of the river.
findTravels([], Arrival, Travels, Travels).

% We do a transportation and a return

findTravels(Departure, Arrival, PreviousTravels, TravelsOut):-
        transport(Departure, Arrival, X, Y, NewDeparture, NewArrival),
        not(member(PreviousTravels, [[X, Y]])), % We dont want a loop
        not(member(PreviousTravels, [[Y, X]])),
        append(PreviousTravels, [[X, Y]], NewTravels),
        %findTravels(NewArrival, NewDeparture, NewTravelsReturn, TravelsOut).
        findTravels(NewDeparture, NewArrival, NewTravels, TravelsOut).
