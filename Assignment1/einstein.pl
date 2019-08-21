:- use_module(library(lists)).

/* layout of owner data item */
owner(owner(Nationality, Position,  Drink, Cigar, Pet, Color), Nationality, Position, Drink, Cigar, Pet, Color).

/*   field accessors/setters for owner data item  general form: owner_<field name>(<owner data item>, <field value>)  these predicates can be used both for accessing and for setting the field values*/
owner_Nationality(owner(Nationality, _Position, _Drink, _Cigar, _Pet, _Color), Nationality).
owner_Position(owner(_Nationality, Position, _Drink, _Cigar, _Pet, _Color), Position).
owner_Drink(owner(_Nationality, _Position, Drink, _Cigar, _Pet, _Color), Drink).
owner_Cigar(owner(_Nationality, _Position, _Drink, Cigar, _Pet, _Color), Cigar).
owner_Pet(owner(_Nationality, _Position, _Drink, _Cigar, Pet, _Color), Pet).
owner_Color(owner( _Nationality, _Position, _Drink, _Cigar, _Pet, Color), Color).

/*   these are the domains (possible values) for the different fields, they were manually extracted from the puzzle descriptions*/
position([1,2,3,4,5]).
nationality([norwegian, brit, swede, dane, german]).
drink([water, beer, milk, coffee, tea]).
cigar([dunhill, blueMaster, pallMall, prince, blends]).
pet([horses, dog, cat, bird, fish]).
color([blue, green, red, white, yellow]).

/*  This is the actual encoding of the clues */
solution(Persons) :-


/*     Persons is the variable containing the people data items for each owner     */
Persons = [Norwegian, Brit, Swede, Dane, German],
/*     setting up the values that we already know   */
owner(Norwegian, norwegian, NorwegianPosition, NorwegianDrink, NorwegianCigar, NorwegianPet, NorwegianColor),
owner(Brit, brit, BritPosition, BritDrink, BritCigar, BritPet, BritColor),
owner(Swede, swede, SwedePosition, SwedeDrink, SwedeCigar, SwedePet, SwedeColor),
owner(Dane, dane, DanePosition, DaneDrink, DaneCigar, DanePet, DaneColor),
owner(German, german, GermanPosition, GermanDrink, GermanCigar, GermanPet, GermanColor),
position(Position),
drink(Drink),
cigar(Cigar),
pet(Pet),
color(Color),

/* POSITIVE CLUES */
/* clue 1 the Brit lives in the red house */
owner_Color(Brit, red),

/* clue 2 the Swede keeps dogs as pets */
owner_Pet(Swede,dog),

/* clue 3 the Dane drinks tea */
owner_Drink(Dane,tea),

/*clue 13 the German smokes Prince */
owner_Cigar(German,prince),

/*clue 9 the Norwegian lives in the first position */
owner_Position(Norwegian,1),

/*clue 14 the Norwegian lives next to the blue owner */
owner_Color(Blue, blue),
member(Blue,Persons),
owner_Position(Blue, 2), %%this is given since the Norwegians live in the first owner

/* clue 4 the green owner is on the left of the white owner */
owner_Color(Green,green),
member(Green,Persons),
owner_Position(Green,GreenPosition),
member(GreenPosition,Position),
owner_Color(White,white),
member(White,Persons),
owner_Position(White,WhitePosition),
member(WhitePosition,Position),
GreenPosition is WhitePosition -1,

/*clue 5 the green owner’s owner drinks coffee */
owner_Color(Green,green),
owner_Drink(Green, coffee),

/*clue 6 the person who smokes Pall Mall rears birds */
owner_Cigar(PallMall, pallMall),
member(PallMall,Persons),
owner_Pet(PallMall,birds),

/*clue 7 the owner of the yellow owner smokes Dunhill */
owner_Color(Yellow,yellow),
member(Yellow,Persons),
owner_Cigar(Yellow, dunhill),

/*clue 8 the man living in the center owner drinks milk */
owner_Drink(Milk, milk),
member(Milk,Persons),
owner_Position(Milk,3),

/*clue 12 the owner who smokes BlueMaster drinks beer */
owner_Cigar(BlueMaster,blueMaster),
member(BlueMaster,Persons),
owner_Drink(BlueMaster,beer),

/*instantiate rest of solution structure */
permutation(Position,
[NorwegianPosition, BritPosition, SwedePosition, DanePosition, GermanPosition]),
permutation(Drink,
[NorwegianDrink, BritDrink, SwedeDrink, DaneDrink, GermanDrink]),
permutation(Cigar, [NorwegianCigar, BritCigar, SwedeCigar, DaneCigar, GermanCigar]),
%permutation(Pet, [NorwegianPet, BritPet, SwedePet, DanePet, GermanPet]),
permutation(Color,
[NorwegianColor, BritColor, SwedeColor, DaneColor, GermanColor]),


/*NEGATIVE CLUES */
/*clue 10 the man who smokes blends lives next to the one who keeps cats */
owner_Cigar(Blends,blends),
member(Blends,Persons),
owner_Position(Blends, BlendsPosition),
member(BlendsPosition,Position),
owner_Pet(Cat, cat),
member(Cat,Persons),
owner_Position(Cat, CatPosition),
member(CatPosition,Position),
(CatPosition is BlendsPosition -1; CatPosition is BlendsPosition +1),

/*clue 11 the man who keeps horses lives next to the man who smokes Dunhill*/
owner_Pet(Horses, horses),
member(Horses,Persons),
owner_Position(Horses, HorsesPosition),
member(HorsesPosition,Position),
owner_Cigar(Dunhill,dunhill),
member(Dunhill,Persons),
owner_Position(Dunhill, DunhillPosition),
member(DunhillPosition,Position),
(HorsesPosition is DunhillPosition + 1;HorsesPosition is DunhillPosition - 1),

/*clue 15 the man who smokes blend has a neighbor who drinks water*/
owner_Drink(Water,water),
member(Water,Persons),
owner_Position(Water, WaterPosition),
member(WaterPosition,Position),
(WaterPosition is BlendsPosition +1; WaterPosition is BlendsPosition -1).

ownerOfFish(Persons, Owner) :- solution(Persons), owner_Pet(FishOwner,fish), member(FishOwner,Persons), owner_Nationality(FishOwner,Owner).
