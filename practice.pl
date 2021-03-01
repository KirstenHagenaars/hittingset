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
   makeTree2(A, C, C, X).
   

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







