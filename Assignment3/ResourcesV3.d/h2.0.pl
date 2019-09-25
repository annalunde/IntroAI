:- use_module(library(lists)).

notStartState(State,StartState):-
not(State=StartState).

h(State,RoadNetwork,HValue) :-
(length(RoadNetwork,LenRN),LenRN=0 ->  HValue=0);(
StartData = [State:0],
dict_create(Dictionary, Tag, StartData),
Visited = [],
h2(State,RoadNetwork,Dictionary,Visited,[State],HValue)).

h2(State,RoadNetwork,Dictionary,Visited,AddedNodes,HValue):-
(length(RoadNetwork,LenRN), length(Visited,VLen), VLen=LenRN -> addTog(Dictionary,AddedNodes,HValue));(
member((NewNode,NewEdges),RoadNetwork), not(member(NewNode,Visited)),
addAdj(State,NewEdges,[],Dictionary,AddedNodes,DoneAddedNodes,NewDictionary),
append([NewNode],Visited,NewVisited),
h2(State,RoadNetwork,NewDictionary,NewVisited,DoneAddedNodes,HValue)).

addAdj(State,NewEdges,VisitedAdj,Dictionary,InitAdd,AddedNodes,NewDictionary):-
((numOfNodes(NewEdges,LenNE),length(VisitedAdj,VisAL),LenNE=VisAL) -> AddedNodes=InitAdd, NewDictionary = Dictionary);(
((member((NewAdjNode,NewCost),NewEdges), not(member(NewAdjNode,VisitedAdj)),
notStartState(NewAdjNode,State),not(member(NewAdjNode,InitAdd))) ->  Data = [NewAdjNode:NewCost],
append([NewAdjNode],InitAdd,NewAdded),put_dict(Data,Dictionary,NewDictOut), append([NewAdjNode],VisitedAdj,NewVisitedAdj),
addAdj(State,NewEdges,NewVisitedAdj,NewDictOut,NewAdded,AddedNodes,NewDictionary));
(( member((NewAdjNode,NewCost),NewEdges), not(member(NewAdjNode,VisitedAdj)),
notStartState(NewAdjNode,State),get_dict(NewAdjNode,Dictionary,Value),NewCost<Value) ->
Data = [NewAdjNode:NewCost],
put_dict(Data,Dictionary,NewDictOut), append([NewAdjNode],VisitedAdj,NewVisitedAdj),
addAdj(State,NewEdges,NewVisitedAdj,NewDictOut,InitAdd,AddedNodes,NewDictionary));(
append([NewAdjNode],VisitedAdj,NewVisitedAdj),addAdj(State,NewEdges,NewVisitedAdj,Dictionary,InitAdd,AddedNodes,NewDictionary))).

numOfNodes(Xs,Num):-
numOfNodes(Xs,0,Num).

numOfNodes([],Num,Num).
numOfNodes([X|Xs],Int,Num):-
(not(integer(X))->
NewInt is Int + 1,
numOfNodes(Xs, NewInt, Num));
numOfNodes(Xs,Int,Num).

addTog(Dict,AddedNodes,Sum):-
addTog2(Dict,AddedNodes,[],0,Sum).

addTog2(Dict,AddedNodes,Traversed,InitSum,Sum):-
(length(Traversed,LenTrav),length(AddedNodes,LenPN), LenPN=LenTrav ->  Sum=InitSum);(
member(Node,AddedNodes), not(member(Node,Traversed)),
get_dict(Node,Dict,Value) -> append([Node],Traversed,NewTrav),NewSum is InitSum + Value,addTog2(Dict,AddedNodes,NewTrav,NewSum,Sum)).
