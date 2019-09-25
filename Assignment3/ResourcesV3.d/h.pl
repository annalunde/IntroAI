h(Start,RoadNetwork,HValue):-
state_stillToVisitCitySet(Start,UnvisitedCities),
minCostCities(UnvisitedCities,RoadNetwork,HValue).

minCostCities([],_,0).
minCostCities([X|Xs],RoadNetwork,Cost):-
(minCostCities(Xs,RoadNetwork,RecCost);RecCost is 0),
minCostSingleState(X,RoadNetwork,MinCost),
Cost is MinCost + RecCost.

minCostSingleState(State,RoadNetwork,MinCost):-
findall(Cost, (member((_,Edges),RoadNetwork), member((State,Cost),Edges)), Costs),
minimum(Costs,MinCost).

minimum([X|Xs],MinCost):-
minimum(Xs,X,MinCost).

minimum([],MinCost,MinCost).
minimum([X|Xs],MidMin,MinCost) :-
X<MidMin,
minimum(Xs,X,MinCost),!;
minimum(Xs,MidMin,MinCost),!.
