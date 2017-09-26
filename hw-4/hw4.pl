% more code from assignment
morse(a, [.,-]).           % A
morse(b, [-,.,.,.]).	   % B
morse(c, [-,.,-,.]).	   % C
morse(d, [-,.,.]).	   % D
morse(e, [.]).		   % E
morse('e''', [.,.,-,.,.]). % É (accented E)
morse(f, [.,.,-,.]).	   % F
morse(g, [-,-,.]).	   % G
morse(h, [.,.,.,.]).	   % H
morse(i, [.,.]).	   % I
morse(j, [.,-,-,-]).	   % J
morse(k, [-,.,-]).	   % K or invitation to transmit
morse(l, [.,-,.,.]).	   % L
morse(m, [-,-]).	   % M
morse(n, [-,.]).	   % N
morse(o, [-,-,-]).	   % O
morse(p, [.,-,-,.]).	   % P
morse(q, [-,-,.,-]).	   % Q
morse(r, [.,-,.]).	   % R
morse(s, [.,.,.]).	   % S
morse(t, [-]).	 	   % T
morse(u, [.,.,-]).	   % U
morse(v, [.,.,.,-]).	   % V
morse(w, [.,-,-]).	   % W
morse(x, [-,.,.,-]).	   % X or multiplication sign
morse(y, [-,.,-,-]).	   % Y
morse(z, [-,-,.,.]).	   % Z
morse(0, [-,-,-,-,-]).	   % 0
morse(1, [.,-,-,-,-]).	   % 1
morse(2, [.,.,-,-,-]).	   % 2
morse(3, [.,.,.,-,-]).	   % 3
morse(4, [.,.,.,.,-]).	   % 4
morse(5, [.,.,.,.,.]).	   % 5
morse(6, [-,.,.,.,.]).	   % 6
morse(7, [-,-,.,.,.]).	   % 7
morse(8, [-,-,-,.,.]).	   % 8
morse(9, [-,-,-,-,.]).	   % 9
morse(., [.,-,.,-,.,-]).   % . (period)
morse(',', [-,-,.,.,-,-]). % , (comma)
morse(:, [-,-,-,.,.,.]).   % : (colon or division sign)
morse(?, [.,.,-,-,.,.]).   % ? (question mark)
morse('''',[.,-,-,-,-,.]). % ' (apostrophe)
morse(-, [-,.,.,.,.,-]).   % - (hyphen or dash or subtraction sign)
morse(/, [-,.,.,-,.]).     % / (fraction bar or division sign)
morse('(', [-,.,-,-,.]).   % ( (left-hand bracket or parenthesis)
morse(')', [-,.,-,-,.,-]). % ) (right-hand bracket or parenthesis)
morse('"', [.,-,.,.,-,.]). % " (inverted commas or quotation marks)
morse(=, [-,.,.,.,-]).     % = (double hyphen)
morse(+, [.,-,.,-,.]).     % + (cross or addition sign)
morse(@, [.,-,-,.,-,.]).   % @ (commercial at)

% Error.
morse(error, [.,.,.,.,.,.,.,.]). % error - see below

% Prosigns.
morse(as, [.,-,.,.,.]).          % AS (wait A Second)
morse(ct, [-,.,-,.,-]).          % CT (starting signal, Copy This)
morse(sk, [.,.,.,-,.,-]).        % SK (end of work, Silent Key)
morse(sn, [.,.,.,-,.]).          % SN (understood, Sho' 'Nuff)

% base case
get_sign([],[]).

% match on 1s
get_sign([1],['.']).
get_sign([1,1],['.']).
get_sign([1,1],['-']).
get_sign([1,1,1|_],['-']).

% match on 0s
get_sign([0],[]).
get_sign([0,0],[]).
get_sign([0,0],['^']).
get_sign([0,0,0],['^']).
get_sign([0,0,0,0],['^']).
get_sign([0,0,0,0,0],['^']).
get_sign([0,0,0,0,0],['#']).
get_sign([0,0,0,0,0,0|_],['#']).

% base cases
signal_morse_helper([], [], []).
signal_morse_helper([], L, S):- get_sign(L,S). 

% change from 0 or 1 so get sign
signal_morse_helper([H|T], [X|L], R):- H =\= X, get_sign([X|L], S), signal_morse_helper(T, [H], R1), append(S, R1, R).

% no change keep recursing
signal_morse_helper([H|T], [H|L], R):- signal_morse_helper(T, [H,H|L], R). 

% call helper function
signal_morse([H|T], R):- signal_morse_helper(T, [H], R).

% reverse a list
reverse([L,R]):- revapp(L, [], R).
revapp([], A, A).
revapp([H|T], A, R):- revapp(T, [H|A], R).

% remove word before error 
remove_partial_word([], []).
remove_partial_word(['#'|T], ['#'|T]). 
remove_partial_word([_|T], R):- remove_partial_word(T, R). 

% find error keywords in list
find_errors([], L, L).
find_errors(['error'|T], L, R):- remove_partial_word(T,R1), append(L, R1, R). 
find_errors([H|T], L, R):- append(L, [H], K), find_errors(T, K, R). 

% wrapper function for error handling
handle_errors([], []).
handle_errors(L, R):- reverse(L, R1), find_errors(R1, [], R2), reverse(R2, R).

% base case 1
match_morse([], [], []).

% base case 2: list is empty, but acc is not so run through morse code translation
match_morse([], L, [R]):- morse(R,L).

% call morse with accumulated list when theres a letter break or new word
match_morse(['^',H|T], L, [R1|R2]):- morse(R1, L), match_morse(T, [H], R2). 
match_morse(['#',H|T], L, [R1,'#'|R2]):- morse(R1, L), match_morse(T, [H], R2). 

% otherwise keep building list
match_morse([H|T], L, R):- append(L, [H], K), match_morse(T, K, R). 

% first convert to symbols then run through morse matcher then remove errors
signal_message(L, R) :- signal_morse(L,R1), match_morse(R1, [], R2), once(handle_errors(R2, R)).

