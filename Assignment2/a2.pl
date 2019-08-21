goal_test(Goal, State) :-
Goal = State.

append([],Y,Y).
append([X|L],Y,[X|Z]) :- append(L,Y,Z).

sum([],0).
sum([Number|RestOfList],Sum) :- sum(RestOfList,SubSum), Sum is Number+SubSum.

reverse(X,Y) :- reverseAux(X,[],Y).
reverseAux([],X,X).
reverseAux([X|Y],Z,W):- reverseAux(Y,[X|Z],W).

solution(Path,RoadNetwork,SolutionCost,Solution) :-
member(Goal,Path),
((length(RoadNetwork,L),L<2,member((State,Cost),RoadNetwork), goal_test(Goal,State)) ->sum(Cost,SolutionCost),append(Path,Path,Solution));(
member(Goal,Path),
member((Goal,Edges), RoadNetwork),
member((NextState,Cost),Edges),
solution2(RoadNetwork,NextState, Goal, [NextState], [Cost], SolutionCost, Solution)).

solution2(RoadNetwork,NextState,Goal,DiscoveredStates, Costs,SolutionCost, Solution) :-
member((NextState,Edges), RoadNetwork), member((NextNextState,Costs2),Edges),
not(member(NextNextState,DiscoveredStates)),
append([NextNextState],DiscoveredStates,DiscoveredStatesTemp),
append([Costs2],Costs,CostsTemp),
((goal_test(Goal,NextNextState),length(RoadNetwork,L),length(DiscoveredStatesTemp,X), L=X->
(append(DiscoveredStatesTemp,[Goal],Reverse2),reverse(Reverse2,Solution),sum(CostsTemp,SolutionCost)))
;(solution2(RoadNetwork,NextNextState,Goal,DiscoveredStatesTemp, CostsTemp,SolutionCost, Solution))).
