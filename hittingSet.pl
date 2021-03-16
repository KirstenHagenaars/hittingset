:- [diagnosis].

% makeChildren(+SD, +COMP, +OBS, +LABEL, +CS, -CHILDREN)
%             - Determines the children of a node for a given diagnostic problem (SD,COMP,OBS), label of that node (LABEL) and conflict set (CS).

makeChildren(SD, COMP, OBS, LABEL, [EL], [CHILD]):-
   union(LABEL, [EL], NEWLABEL),
   makeHittingTree(SD, COMP, OBS, NEWLABEL, CHILD).

makeChildren(SD, COMP, OBS, LABEL, [EL|REMAINDER], [CHILD|CHILDREN]):-
   union(LABEL, [EL], NEWLABEL),
   makeHittingTree(SD, COMP, OBS, NEWLABEL, CHILD),
   makeChildren(SD, COMP, OBS, LABEL, REMAINDER, CHILDREN).
   
%  makeHittingTree(+SD,+COMP, +OBS, +LABEL, -TREE)  
%             - Determines a hitting tree for a given diagnostic problem (SD,COMP,OBS).

makeHittingTree(SD, COMP, OBS, LABEL, node(CHILDREN, LABEL)):-
   tp(SD, COMP, OBS, LABEL, CS),
   makeChildren(SD, COMP, OBS, LABEL, CS, CHILDREN).

makeHittingTree(SD, COMP, OBS, LABEL, leaf(LABEL)).

%  gatherDiagnoses(+TREE, -D)  
%             -  Determines a list of diagnoses D from hittingTree TREE.

gatherDiagnoses(leaf(LABEL),[LABEL]).

gatherDiagnoses(node([CHILD],X),LABEL):-
   gatherDiagnoses(CHILD, LABEL).

gatherDiagnoses(node([CHILD|CHILDREN],X), ALL):-
   gatherDiagnoses(CHILD, CHILDLABELS),
   gatherDiagnoses(node(CHILDREN,Y), CHILDRENLABELS),
   append(CHILDLABELS, CHILDRENLABELS, ALL).

%  existsSubset(+SET, +REMAINDER)
%             -  Succeeds if there exists a subset of SET within REMAINDER.

existsSubset(X, [HEAD|TAIL]):-
   subset(HEAD, X).

existsSubset(X, [HEAD|TAIL]):-
   existsSubset(X, TAIL).


% removeSupersets(+SET, +REMAINDER, -NEWREMAINDER)
%             -  Removes supersets of SET from REMAINDER.

removeSupersets(SET, [], []).

removeSupersets(SET, [HEAD|TAIL], [HEAD|RESULT]):-
   subset(SET, HEAD),
   subset(HEAD, SET),
   removeSupersets(SET, TAIL, RESULT).

removeSupersets(SET, [HEAD|TAIL], RESULT):-
   subset(SET, HEAD),
   removeSupersets(SET, TAIL, RESULT).

removeSupersets(SET, [HEAD|TAIL], [HEAD|RESULT]):-
   removeSupersets(SET, TAIL, RESULT).

%  getMinimalDiagnoses(+D, -MD)  
%             -  Determines a list of minimal diagnoses MD from list of diagnoses D.

getMinimalDiagnoses([],[]).

getMinimalDiagnoses([SET|REMAINDER], RESULT):-  
   existsSubset(SET, REMAINDER),
   removeSupersets(SET, REMAINDER, NEWREMAINDER),
   getMinimalDiagnoses(NEWREMAINDER, RESULT).

getMinimalDiagnoses([SET|REMAINDER], [SET|RESULT]):-
   removeSupersets(SET, REMAINDER, NEWREMAINDER),
   getMinimalDiagnoses(NEWREMAINDER, RESULT).

%  main(+SD, +COMP, +OBS, -MD) 
%             -  Determines a list of minimal diagnoses MD from a diagnostic problem (SD,COMP,OBS).

main(SD, COMP, OBS, MD):-
   makeHittingTree(SD, COMP, OBS, [], TREE),
   gatherDiagnoses(TREE, D),
   getMinimalDiagnoses(D, MD),
   !.