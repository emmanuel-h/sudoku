%sudoku(+File,+LineLength)
sudoku(File,LineLength):-
    Size is round(sqrt(LineLength)),
	BlocLength is LineLength*Size,
	TotalLength is BlocLength*Size,
	length(LV,TotalLength),
	fd_domain(LV,1,LineLength),
	listLines([],LV,LineLength,LineLength),
	listColumns([],LV,LineLength,LineLength),
	listBlocs([],LV,BlocLength,BlocLength,LineLength,Size),
	see(File),
	readConstraints(LV,LineLength),
	seen,
	fd_labeling(LV),!,
	display(LV,LineLength,LineLength,Size,TotalLength).

display([T|LV],LineLength,InitialLineLength,Size,InitialLength):-
	write(T),
	Size2 is Size-1,
	SizeLine2 is LineLength-1,
	write(' '),
	(SizeLine2 = 0 ->
	nl,
	display(LV,InitialLineLength,InitialLineLength,InitialLength,InitialLength);
	display(LV,SizeLine2,InitialLineLength,Size2,InitialLength)).
	
	
findPosition([T|_],1,Value):-
	T #= Value.
findPosition([_|LV],Position,Value):-
	Position > 1,
	Position2 is Position-1,
	findPosition(LV,Position2,Value).
	
addConstraints(LV,Line,Column,Value,LineLength):-
	Position is (Line-1)*LineLength + Column,
	findPosition(LV,Position,Value). 
	
readConstraints(LV,LineLength):-
    read(Line),
    (Line=end_of_file ->
    !;
    read(Column),
    read(Value),
    addConstraints(LV,Line,Column,Value,LineLength),
    readConstraints(LV,LineLength)
    ).
    
% Add constraints for the lines
listLines(LL,[],0,_):-	
	fd_all_different(LL),
	!.
listLines(LL,LV,0,Size):-
	fd_all_different(LL),
	listLines([],LV,Size,Size).
listLines(LL,[T|LV],ActualLength,Size):-
	NewLength is ActualLength - 1,
	listLines([T|LL],LV,NewLength,Size).

% Add constraints for the columns
listColumns2(LC,[],_,_):-
	fd_all_different(LC).
listColumns2(LC,[T|LV],1,Size):-
	listColumns2([T|LC],LV,Size,Size).
listColumns2(LC,[_|LV],ActualLength,Size):-
	ActualLength \== 1,
	ActualLength2 is ActualLength -1,
	listColumns2(LC,LV,ActualLength2,Size).
	
listColumns(_,_,0,_).
listColumns(LC,LV,ActualLength,Size):-
	ActualLength \== 0,
	listColumns2(LC,LV,ActualLength,Size),
	ActualLength2 is ActualLength-1,
	listColumns(LC,LV,ActualLength2,Size).

% Add constraints for the blocs
listBlocs3(LB,[],_,_,_):-
    fd_all_different(LB),!.
listBlocs3(LB,LV,0,LineLength,Size):-
    listBlocs3(LB,LV,LineLength,LineLength,Size).
listBlocs3(LB,[_|LV],ActualLength,LineLength,Size):-
    ActualLength > 0,
    ActualLength > Size,
    ActualLength2 is ActualLength-1,
    listBlocs3(LB,LV,ActualLength2,LineLength,Size).
listBlocs3(LB,[T|LV],ActualLength,LineLength,Size):-
    ActualLength > 0,
    ActualLength =< Size,
    ActualLength2 is ActualLength-1,
    listBlocs3([T|LB],LV,ActualLength2,LineLength,Size).

listBlocs2(_,_,0,_,_).
listBlocs2(LB,LV,ActualLength,LineLength,Size):-
    ActualLength > 0,
    0 is ActualLength mod Size,
    listBlocs3(LB,LV,ActualLength,LineLength,Size),
    ActualLength2 is ActualLength-1,
    listBlocs2(LB,LV,ActualLength2,LineLength,Size).
listBlocs2(LB,LV,ActualLength,LineLength,Size):-
    ActualLength > 0,
    ActualLength2 is ActualLength -1,
    listBlocs2(LB,LV,ActualLength2,LineLength,Size).


listBlocs(LB,LV,0,BlocLength,LineLength,Size):-
    listBlocs2([],LB,LineLength,LineLength,Size),
    listBlocs([],LV,BlocLength,BlocLength,LineLength,Size).
listBlocs(_,[],_,_,_,_).
listBlocs(LB,[T|LV],ActualLength,BlocLength,LineLength,Size):-
    ActualLength2 is ActualLength-1,
    listBlocs([T|LB],LV,ActualLength2,BlocLength,LineLength,Size).

