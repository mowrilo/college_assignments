hsearch(_,_,[]).
hsearch(X, Y, [H|T]) :- char(X,Y,H), Y1 is Y+1, hsearch(X,Y1,T).

vsearch(_,_,[]).
vsearch(X, Y, [H|T]) :- char(X,Y,H), X1 is X+1, vsearch(X1,Y,T).

wmember([]).
wmember(W) :- hsearch(X,Y,W); vsearch(X,Y,W).

isin(_,[]).
isin(X,[H|T]) :- X = H; isin(X,T).
isin([H|T],L) :- isin(H,L), isin(T,L).

answers(L, S) :- wmember(S), isin(L, S).
