relation(nonfiction, isa, book).
relation(fiction, isa, book).
relation(novel, isa, fiction).
relation('The Guide', isa, novel).
relation('Michael Strogoff', isa, fiction).
relation('OED', isa, dictionary).
relation('Websters', isa, dictionary).
relation('Johnstons', isa, dictionary).
relation(dictionary, isa, nonfiction).
relation('Flour Water Salt Yeast', isa, cookbook).
relation(cookbook, isa, nonfiction).
relation(A, B):-
    relation(A, isa, C) , relation(C, isa, D) , relation(D, isa, B) ;
    relation(A, isa, C) , relation(C, isa, B) ;
    relation(A, isa, B).
