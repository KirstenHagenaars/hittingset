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

:- [diagnosis].

hittingTree(leaf(L)).
hittingTree(node([X], L)):-
   hittingTree(X).
hittingTree(node([X|Y], L)):-
   hittingTree(X),
   hittingTree(node(Y, L)).

% This function has been replaced by subtract, can be deleted
deleteList(COMP, [], COMP).
deleteList(COMP, [X|Y], COMPSMALL):-
   delete2(COMP, X, COMP2),
   deleteList(COMP2, Y, COMPSMALL).

% func([], LABEL, leaf(LABEL)).
% func([X|Y], LABEL, node(HI,LABEL)):-
%   makeHittingTree.

%========== Suggestion ============
%  makeHittingTree(+SD,+COMP, +OBS, -TREE)  
%             -  Determines a hitting tree for the diagnostic problem (SD,COMP,OBS).

% We put UNION as HS since this is subtracted in tp
% Do we need the definition of hittingTree? I think its implicitly defined by makeHittingTree

makeChildren(SD, COMP, OBS, LABEL, []):-
   tp(SD, COMP, OBS, LABEL, []).

makeChildren(SD, COMP, OBS, LABEL, CHILDREN):-
   % Remove label of parent and generate CS
   tp(SD, COMP, OBS, LABEL, CS),
   % TODO: call makeHittingTree for each element (el) of CS, where that element is added to the label
   % for this we need to know whether this child is a leaf or a node, which we dont. 
   % Prolog might figure it out if we give both options: makeHittingTree(SD, COMP, OBS, leaf(LABEL+el)); makeHittingTree(SD, COMP, OBS, node(A,LABEL+el))
   .
   

makeHittingTree(SD, COMP, OBS, leaf(LABEL)):-
   makeChildren(SD, COMP, OBS, LABEL, []).

makeHittingTree(SD, COMP, OBS, node(CHILDREN, LABEL)):-
   makeChildren(SD, COMP, OBS, LABEL, CHILDREN).

%====================================

makeHittingTree(SD, COMP, OBS, node([leaf(UNION)], LABEL), [CS]):-
   union(LABEL, [CS], UNION), 
   subtract(COMP, UNION, COMPSMALL),
   tp(SD, COMPSMALL, OBS, [], []).
makeHittingTree(SD, COMP, OBS, node([node(TREE,UNION)], LABEL), [CS]):-
   union(LABEL, [CS], UNION),
   subtract(COMP, UNION, COMPSMALL),
   tp(SD, COMPSMALL, OBS, [], CSRESULT),
   makeHittingTree(SD, COMP, OBS, TREE, CSRESULT).


%  gatherDiagnoses(+TREE, -D)  
%             -  Determines a list of diagnoses D from hittingTree TREE

%  getMinimalDiagnoses(+D, -MD)  
%             -  Determines a list of minimal diagnoses MD from list of diagnoses D








