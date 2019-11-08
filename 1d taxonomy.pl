relation(nonfiction, isa, book).
relation(fiction, isa, book).
relation(novel, isa, fiction).
relation('The Guide', isa, novel).
relation('Michael Strogoff', isa, fiction).
relation('OED', isa, dictionary).
relation('Websters', isa, dictionary).
relation('Johnstons', isa, dictionary).
relation(dictionary, isa, nonfiction).
relation(book, hasvolume, '1').
relation(cookbook, isa, nonfiction).
relation(book, has, editors).
relation(fiction, has, author).
relation('Flour Water Salt Beast', isa, cookbook).
relation('The Guide', hasauthor, 'RK').
relation('Michael Strogoff', hasauthor, 'Jules').
relation('OED', hasvolume, '20').
relation('Websters', hasauthor, 'Noah').
relation('Johnstons', hasauthor, 'Samuel').
agree('Johnstons', 'Websters').
agree('Johnstons', 'Johnstons').
agree('Johnstons', 'OED').
agree('Websters', 'Johnstons').

relation(A, C):-
    relation(A, hasvolume, C);
    relation(A, isa, B) , relation(B, hasvolume, C),
	relation(A, isa, B) , relation(B, isa, D) , relation(D, hasvolume, C) ;
	relation(A, isa, B) , relation(B, isa, D) , relation(D, isa, Q) , relation(Q, hasvolume, C).
