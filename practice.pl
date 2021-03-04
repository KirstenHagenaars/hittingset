isBinaryTree(leaf(X)).
isBinaryTree(node(X, Y, Z)):-
   isBinaryTree(X),
   isBinaryTree(Y).
   
add(0,Y,Y).
add(s(X),Y,s(Z)) :-
        add(X,Y,Z).
        
nnodes(leaf(X),1).
nnodes(node(X,Y,Z), N):-
   nnodes(X, M),
   nnodes(Y, O), 
   N is M+O+1.
   
makeBinary(0,leaf(0)).
makeBinary(A,node(X,Y,A)):-
   succ(N,A),
   makeBinary(N,X),
   makeBinary(N,Y).  
   
tree(leaf).
tree(node([X])):-
   tree(X).
tree(node([X|Y])):-
   tree(X),
   tree(node(Y)).

makeTree(0, C, leaf).
makeTree(A, C, X):-
   makeTree3(A, C, C, X).

% old function (not working)
makeTree2(0, C, R, leaf).
makeTree2(A, C, 0, T).
makeTree2(A, C, 1, node([X])):-
   succ(N,A),
   tree(X),
   makeTree2(N, C, C, X).
makeTree2(A, C, R, node([X|Y])):-
   length([X|Y],R),
   succ(N,A),
   succ(D,R),
   tree(X),
   makeTree2(N, C, C, X),
   makeTree2(N, C, D, node(Y)).

% new function (working :))
makeTree3(A, C, 0, node([])).
makeTree3(1, C, C, node(X)):-
   !,
   leaves(C, X).
makeTree3(1, C, R, node([X|Y])):-
   length([X|Y], R),
   succ(D, R),
   makeTree3(1, C, C, X),
   makeTree3(1, C, D, node(Y)).
makeTree3(A, C, R, node([X|Y])):-
   length([X|Y], R),
   succ(N, A),
   succ(D, R),
   makeTree3(N, C, C, X),
   makeTree3(A, C, D, node(Y)). % We dont want to decrease A here because we are not actually going one level down

% The tree function was faulty, it always returned:
% X = leaf; X = node([leaf]); X = node([node([leaf])]) ....
% But it never got to cases like X = node([leaf, leaf])
% So this leaves function seemed like the one we need
leaves(1, [leaf]).
leaves(Y, [leaf|L]):-
   succ(X, Y),
   leaves(X, L).







