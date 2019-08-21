%% Assignemnt1

%% Problem 3: Predicate Logic in Prolog
halfSisterOf(HalfSister,Person) :- female(HalfSister),parentOf(Parent1,Person),parentOf(Parent1,HalfSister),not(=(Person,HalfSister)), parentOf(Parent2,Person), parentOf(Parent3,HalfSister), not(=(Parent2,Parent3)).
