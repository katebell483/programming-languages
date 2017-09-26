father(homer, bart).
father(homer, lisa).
father(homer, maggie).
father(grandpa, homer).
father(grandpa, herb).

mother(marge, bart).
mother(marge, lisa).
mother(marge, maggie).
mother(grandma, homer).

paternal_grandfather(X, Y) :- father(X, Z), father(Z, Y).

paternal_grandmother(X, Y) :- mother(X, Z), father(Z, Y).

likes(john, susie).                   /* John likes Susie */
likes(X, susie).                      /* Everyone likes Susie */
likes(john, Y).                       /* John likes everybody */
likes(john, Y), likes(Y, john).       /* John likes everybody and everybody likes John */
likes(john, susie); likes(john,mary). /* John likes Susie or John likes Mary */
not(likes(john,pizza)).               /* John does not like pizza */
likes(john,susie) :- likes(john,mary). /* John likes Susie if John likes Mary. */

/* valid rules */
/* friends(X,Y) :- likes(X,Y),likes(Y,X).            /* X and Y are friends if they like each other */
/* hates(X,Y) :- not(likes(X,Y)).                    /* X hates Y if X does not like Y. */
/* enemies(X,Y) :- not(likes(X,Y)),not(likes(Y,X)).  /* X and Y are enemies if they don't like each other */ 

/* invalid rules */
/* Examples of invalid rules:
left_of(X,Y) :- right_of(Y,X) //no period!                   
likes(X,Y),likes(Y,X) :- friends(X,Y).      //cant have two conclusions. separate into two different lines      
not(likes(X,Y)) :- hates(X,Y). //can't use not operator */

non_symm_adjacent(1,2).
non_symm_adjacent(1,3).
non_symm_adjacent(1,4).
non_symm_adjacent(1,5).
non_symm_adjacent(2,3).
non_symm_adjacent(2,4).
non_symm_adjacent(3,4).
non_symm_adjacent(4,5).

%true if X is adjacent to Y
% if 1 is adjacent to 2 then 2 is adjacent to 1
%adjacent(1,2)->true
%adjacent(2,1)->true
adjacent(X,Y) :- non_symm_adjacent(X,Y).
adjacent(X,Y) :- non_symm_adjacent(Y,X).

%color scheme 'a'
color(1,red,a).
color(2,blue,a).
color(3,green,a).
color(4,yellow,a).
color(5,blue,a).

%color scheme 'b'
color(1,red,b).
color(2,blue,b).
color(3,green,b).
color(4,blue,b).
color(5,green,b).

% Q if R1 and R2 (integers) are adjacent regions which have the same color under the scheme
conflict(R1,R2, Scheme) :- adjacent(R1,R2), color(R1,Z,Scheme), color(R2,Z,Scheme). /* this is like and */

% be careful of what equal signs you use because they mean different things = vs ==

% how do we define a list and then multiply each element in it
% ex. scalarMult(3,[2,7,4], Result) should yield Result = [6,21,12]

% list with one element [X]. with two elements [H|T]
scalarMult(Scalar,[X],[Result]) :- Result is X*Scalar. 
scalarMult(Scalar,[H|T],[HResult | TResult]) :- HResult is H*sclaar, scalarMult(Scalaar,T,Tresult). 

% now lets do the dot product of two vectors
% dot([2,5,6],[3,4,1], Result). should yield Result - 32
dot([Vec1],[Vec2], Result) :- Result is Vec1*Vec2.
dot([HVec1|TVec1],[HVec2|TVec2], Result) :- dot(TVec1, TVec2, Y), Result is HVec1*HVec2+Y.

append_([],L2,L2). % fact not a rule
append_([H1|T1], L2, [H1|TResult]) :- append_(T1, L2, TResult).     


%prefix_([],[1,2,3]) is yes
%prefix_([1],[1,2,3]) is yes
%prefix_([2],[1,2,3]) is no

% logically if something can be added to p returns l then p is a prefix
prefix_(P,L) :- append_(P,_,L).

%suffix - do at home

%sublist([2],[1,2,3]) is yes
sublist(SubL,L):- append_(_Subl,X), append_(X,_,L).

%member(E,L) E is true if E is an element of list L
% check first element and then of course its true
member(E,[E|T]).
member(E,[H|T]) :- member(E,T).

% recursively defined 
%index(List,Element,R)
%index([7,8,9],8,1)

index([H|T], H,0).
index([H|T],H,Inx) :- index(T,E, inx0), inx0 is Idx - 1, indx0 is >= 0.









