/*  Exemple d'utilisation pour un sudoku 9*9 et un fichier avec les contraintes	nommé sudoku9x9.txt :
	sudoku('sudoku9x9.txt',9).*/

%sudoku(+File,+TailleLigne)
sudoku(File,TailleLigne):-
    Taille is round(sqrt(TailleLigne)),
	TailleBloc is TailleLigne*Taille,
	TailleTotale is TailleBloc*Taille,
	length(LV,TailleTotale),
	fd_domain(LV,1,TailleLigne),
	listeLignes([],LV,TailleLigne,TailleLigne),
	listeColonnes([],LV,TailleLigne,TailleLigne),
	listeBlocs([],LV,TailleBloc,TailleBloc,TailleLigne,Taille),
	see(File),
	lireContraintes(LV,TailleLigne),
	seen,
	fd_labeling(LV),!,
	afficher(LV,TailleLigne,TailleLigne,Taille,Taille,TailleTotale).

afficher([T|LV],TailleLigne,TailleLigneInitial,Taille,TailleInitiale):-
	write(T),
	Taille2 is Taille-1,
	TailleLigne2 is TailleLigne-1,
	write(' '),
	(TailleLigne2 = 0 ->
	nl,
	afficher(LV,TailleLigneInitial,TailleLigneInitial,TailleInitiale,TailleInitiale);
	afficher(LV,TailleLigne2,TailleLigneInitial,Taille2,TailleInitiale)).
	
	
trouverPosition([T|_],1,Valeur):-
	T #= Valeur.
trouverPosition([_|LV],Position,Valeur):-
	Position > 1,
	Position2 is Position-1,
	trouverPosition(LV,Position2,Valeur).
	
ajouterContraintes(LV,Ligne,Colonne,Valeur,TailleLigne):-
	Position is (Ligne-1)*TailleLigne + Colonne,
	trouverPosition(LV,Position,Valeur). 
	
lireContraintes(LV,TailleLigne):-
    read(Ligne),
    (Ligne=end_of_file ->
    !;
    read(Colonne),
    read(Valeur),
    ajouterContraintes(LV,Ligne,Colonne,Valeur,TailleLigne),
    lireContraintes(LV,TailleLigne)
    ).
    
listeLignes(LL,[],0,_):-	
	fd_all_different(LL),
	!.
listeLignes(LL,LV,0,Taille):-
	fd_all_different(LL),
	listeLignes([],LV,Taille,Taille).
listeLignes(LL,[T|LV],TailleActuelle,Taille):-
	NouvelleTaille is TailleActuelle - 1,
	listeLignes([T|LL],LV,NouvelleTaille,Taille).

listeColonnes2(LC,[],_,_):-
	fd_all_different(LC).
listeColonnes2(LC,[T|LV],1,Taille):-
	listeColonnes2([T|LC],LV,Taille,Taille).
listeColonnes2(LC,[_|LV],TailleActuelle,Taille):-
	TailleActuelle \== 1,
	TailleActuelle2 is TailleActuelle -1,
	listeColonnes2(LC,LV,TailleActuelle2,Taille).
	
listeColonnes(_,_,0,_).
listeColonnes(LC,LV,TailleActuelle,Taille):-
	TailleActuelle \== 0,
	listeColonnes2(LC,LV,TailleActuelle,Taille),
	TailleActuelle2 is TailleActuelle-1,
	listeColonnes(LC,LV,TailleActuelle2,Taille).

listeBlocs3(LB,[],_,_,_):-
    fd_all_different(LB),!.
listeBlocs3(LB,LV,0,TailleLigne,Taille):-
    listeBlocs3(LB,LV,TailleLigne,TailleLigne,Taille).
listeBlocs3(LB,[_|LV],TailleActuelle,TailleLigne,Taille):-
    TailleActuelle > 0,
    TailleActuelle > Taille,
    TailleActuelle2 is TailleActuelle-1,
    listeBlocs3(LB,LV,TailleActuelle2,TailleLigne,Taille).
listeBlocs3(LB,[T|LV],TailleActuelle,TailleLigne,Taille):-
    TailleActuelle > 0,
    TailleActuelle =< Taille,
    TailleActuelle2 is TailleActuelle-1,
    listeBlocs3([T|LB],LV,TailleActuelle2,TailleLigne,Taille).

listeBlocs2(_,_,0,_,_).
listeBlocs2(LB,LV,TailleActuelle,TailleLigne,Taille):-
    TailleActuelle > 0,
    0 is TailleActuelle mod Taille,
    listeBlocs3(LB,LV,TailleActuelle,TailleLigne,Taille),
    TailleActuelle2 is TailleActuelle-1,
    listeBlocs2(LB,LV,TailleActuelle2,TailleLigne,Taille).
listeBlocs2(LB,LV,TailleActuelle,TailleLigne,Taille):-
    TailleActuelle > 0,
    TailleActuelle2 is TailleActuelle -1,
    listeBlocs2(LB,LV,TailleActuelle2,TailleLigne,Taille).


listeBlocs(LB,LV,0,TailleBloc,TailleLigne,Taille):-
    listeBlocs2([],LB,TailleLigne,TailleLigne,Taille),
    listeBlocs([],LV,TailleBloc,TailleBloc,TailleLigne,Taille).
listeBlocs(_,[],_,_,_,_).
listeBlocs(LB,[T|LV],TailleActuelle,TailleBloc,TailleLigne,Taille):-
    TailleActuelle2 is TailleActuelle-1,
    listeBlocs([T|LB],LV,TailleActuelle2,TailleBloc,TailleLigne,Taille).

