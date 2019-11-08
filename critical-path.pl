
% prolog code starts here


% critical path checker
criticalPath(Task, GivenPath) :-	
	prerequisite(Task, Prereq),
	criticalPath(Prereq, Task, GivenPath),
	get_cric_pathsum(G, 0, Y).


% calculating early finish for a node
earlyFinish(Task, GivenTime):-
    find_critical_path_efinish(Task, GivenTime, 0).	


% determining late start
lateStart(Task, Time) :-
	critical_path_lstart(Task, CriticalPath, Time, Time),
	path_sum_lstart(CriticalPath, MaxSum2, [], Time, Time).


% determining the maximum slack
maxSlack(Task, Time):-
	lateStart(Task, Ls),
	duration(Task, Dur),
	Partialsum is Ls+Dur,
	obtain_slack(Task, Partialsum, Summm, Time, Time).


% reversing a list
reverse([],Z,Z).
reverse([H|T],Z,Acc) :- 
	reverse(T,Z,[H|Acc]).


% generating the max duration path for least start
critical_path_lstart(Task, GivenPath, Time, Tim) :-	
	prerequisite(Prereq, Task),
	critical_path_lstart(Prereq, Task, GivenPath, Time, Tim),
	path_sum_lstart(G, 0, Y, Time, Tim).

critical_path_lstart(Prereq, Task, GivenPath, Time, Tim) :-
	prerequisite(X, Prereq),
	critical_path_lstart(X, Task, GivenPath, Time, Tim).
	
critical_path_lstart(Prereq, Task, GivenPath, Time, Tim):-
	prerequisite(X,Task),
	\+ dif(X, Prereq),
	findall(Path, path_edge_cases(Task, Prereq, Path), Sols),
	\+ dif(Tim, Time),
	calc_sum_lstart(Sols, Sols, 0, GivenPath, Time, Tim).

critical_path_lstart(Prereq, Task, GivenPath, Time, Tim) :-
	\+ prerequisite(X, Prereq),
	findall(Path, get_lstart_path(Prereq, Task, Path), Sols),
	\+ dif(Tim, Time),
	calc_sum_lstart(Sols, Sols, 0, GivenPath, Time, Tim).


% determining if prerequisite exists
terminal_nodes_lstart(Task, MaxSum, Time, Tim):-
	prerequisite(X, Task),
	terminal_nodes_lstart(X, MaxSum, Time, Tim).
	
terminal_nodes_lstart(Task, MaxSum, Time, Tim):-
	\+ prerequisite(X, Task),
	critical_full_path_lstart(Task, [MaxSum], Time, Tim).


% summation of values in a list
calc_newsum_lstart([], 0, Time, Tim).
calc_newsum_lstart([H|T], Sum, Time, Tim) :-
	calc_newsum_lstart(T, Rest, Time, Tim),
	duration(H, X),
	Sum is X + Rest.


% generating maximum duration path
check_critical_path_lstart(Sequence, [GivenPath], Time, Tim):-
	reverse(Sequence, NewSequence),
	reverse(NewSequence,[Vall|Seqq]),
	\+prerequisite(Vall, Xxxx),
	calc_newsum_lstart(Sequence, CriticalSum, Time, Tim),
	Time is CriticalSum - GivenPath.

check_critical_path_lstart(Sequence, GivenPath, Time, Tim):-
	\+ dif(Tim, Time),
	calc_newsum_lstart(Sequence, MaxSum, Time, -1),
	reverse(Sequence, [Vall|NewSequence]),
	terminal_nodes_lstart(Vall, MaxSum, Time, -1).
	
is_critical_path_lstart([Max|MaxList], MaxValue, GivenPath, Time, Tim):-
	\+ dif(Max, MaxValue),
	check_critical_path_lstart(MaxList, GivenPath, Time, Tim).

is_critical_path_lstart([Max|MaxList], MaxValue, GivenPath, Time, Tim):-
	dif(Max, MaxValue).


% recursive termination condition
get_path_duration_lstart([], MaxValue, GivenPath, Time, Tim):- !.
	
get_path_duration_lstart([MaxList|Sols], MaxValue, GivenPath, Time, Tim):-
	is_critical_path_lstart(MaxList,MaxValue, GivenPath, Time, Tim),
	get_path_duration_lstart(Sols, MaxValue, GivenPath, Time, Tim).

get_paths_lstart([],[], Sums, Sols, GivenPath, Time, Tim):-
	max_list(Sums, MaxValue),
	get_path_duration_lstart(Sols,MaxValue, GivenPath, Time, Tim).

get_paths_lstart([Sols|A], [Values|R],SumLists, Lis, GivenPath, Time, Tim):-
	reverse(Sols, RevList),
	append([Values], RevList, NewRevList),
	append(Lis, [NewRevList], JList),	
	get_paths_lstart(A,R,SumLists, JList, GivenPath, Time, Tim).


% removing top element from stack
pop_elem_lstart([], R, Sols, GivenPath, Time, Tim):-
	get_paths_lstart(Sols, R,R, [], GivenPath, Time, Tim).

pop_elem_lstart([RR|R], Test, Sols, GivenPath, Time, Tim):-
	pop_elem_lstart([], R, Sols, GivenPath, Time, Tim).

calc_sum_lstart([],Sols, Sum, GivenPath, Time, Tim):-
	flatten(Sum, R),
	pop_elem_lstart(R, [], Sols, GivenPath, Time, Tim).
	
calc_sum_lstart([H|T],Revs, Arr, GivenPath, Time, Tim):-
	path_sum_lstart(H, Sum, GivenPath, Time, Tim),
	calc_sum_lstart(T,Revs,[Arr,Sum], GivenPath, Time, Tim).

path_sum_lstart([], 0, [], Time, Tim):-
	!.
path_sum_lstart([], 0, GivenPath, Time, Tim).
path_sum_lstart([H|T], Sum, GivenPath, Time, Tim) :-
	path_sum_lstart(T, Rest, GivenPath, Time, Tim),
	duration(H, X),
	Sum is X + Rest.


% determining paths with length less than 2
path_edge_cases(Start, Destination, Path) :-
    path_edge_cases(Start, Destination, [], Path).
	path_edge_cases(Start, Start, _ , [Start]).
	path_edge_cases(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Node, Start),
	    path_edge_cases(Node, Destination, [Start|Visited], Nodes).

get_lstart_path(Start, Destination, Path) :-
    get_lstart_path(Start, Destination, [], Path).
	get_lstart_path(Start, Start, _ , [Start]).
	get_lstart_path(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Start, Node),
	    get_lstart_path(Node, Destination, [Start|Visited], Nodes).


critical_full_path_lstart(Task, GivenPath, Time, Tim) :-	
	prerequisite(Task, Prereq),
	critical_full_path_lstart(Prereq, Task, GivenPath, Time, Tim),
	path_sum_lstart(G,0, Y, Time, Tim).

critical_full_path_lstart(Prereq, Task, GivenPath, Time, Tim) :-
	prerequisite(Prereq, X),
	critical_full_path_lstart(X, Task, GivenPath, Time, Tim).


% getting all possible paths to node 	
critical_full_path_lstart(Prereq, Task, GivenPath, Time, Tim) :-
	\+ prerequisite(Prereq, X),
	findall(Path, get_lstart_path(Task, Prereq, Path), Sols),
	calc_sum_lstart(Sols, Sols, 0, GivenPath, Time, Tim).

get_maxval_efinish([MaxTime|RemSumList], SumList, GivenTime, Tom):-
    max_list(SumList, X),
    \+ dif(MaxTime, X),
	GivenTime is MaxTime.

get_maxval_efinish([MaxTime|RemSumList], SumList, GivenTime, Tom):-
    max_list(SumList, X),
    dif(MaxTime, X),
    get_maxval_efinish(RemSumList, RemSumList, GivenTime, Tom).

get_maxval_efinish([], [], GivenTime, Tom):-
    !.

get_efinish_sum([],Sols, Sum, GivenTime, Tom):-
	flatten(Sum, R),
    get_maxval_efinish(R, R, GivenTime, Tom).
	
get_efinish_sum([H|T],Revs, Arr, GivenTime, Tom):-
	calc_sum_efinish(H, Sum, GivenTime, Tom),
	get_efinish_sum(T,Revs,[Arr,Sum], GivenTime, Tom).

calc_sum_efinish([], 0, GivenTime, Tom).
calc_sum_efinish([H|T], Sum, GivenTime, Tom) :-
	calc_sum_efinish(T, Rest, GivenTime, Tom),
	duration(H, X),
	Sum is X + Rest.


% getting early finish path for duration calculation
get_path_efinish(Start, Destination, Path) :-
    get_path_efinish(Start, Destination, [], Path).
	get_path_efinish(Start, Start, _ , [Start]).
	get_path_efinish(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Start, Node),
	    get_path_efinish(Node, Destination, [Start|Visited], Nodes).

find_critical_path_efinish(Task, GivenTime, Tom) :-	
	prerequisite(Task, Prereq),
	find_critical_path_efinish(Prereq, Task, GivenTime, Tom).

find_critical_path_efinish(Task, GivenTime, Tom) :-
    \+ prerequisite(Task, Prereq),
    duration(Task, TaskDuration),
    GivenTime is TaskDuration.

find_critical_path_efinish(Prereq, Task, GivenTime, Tom) :-
	prerequisite(Prereq, X),
	find_critical_path_efinish(X, Task, GivenTime, Tom).
	
find_critical_path_efinish(Prereq, Task, GivenTime, Tom) :-
	\+ prerequisite(Prereq, X),
	findall(Path, get_path_efinish(Task, Prereq, Path), Sols),
	get_efinish_sum(Sols, Sols, 0, GivenTime, Tom).
	
earlyFinish(Task, GivenTime, Tom):-
    find_critical_path_efinish(Task, GivenTime, Tom).	

obtain_slack(Task, Partialsum, Summm, Time, Tom):-
	earlyFinish(Task, Ef, Tom),
	Time is Partialsum - Ef.


% obtaining maximum slack time
get_max_slack(Ls, Ef, Dur, Sum):-
	Sum is Sum + Ls + Dur - Ef.
	
critical_path_check(Sequence, GivenPath):-
	\+ dif(Sequence, GivenPath).

is_critical_path([Max|MaxList], MaxValue, GivenPath):-
	\+ dif(Max, MaxValue),
	critical_path_check(MaxList, GivenPath).


% max duration path identifier
is_critical_path([Max|MaxList], MaxValue, GivenPath):-
	dif(Max, MaxValue).


% path duration checker
duration_critical_path([], MaxValue, GivenPath):- !.

duration_critical_path([MaxList|Sols], MaxValue, GivenPath):-
	is_critical_path(MaxList,MaxValue, GivenPath),
	duration_critical_path(Sols, MaxValue, GivenPath).

get_critical_nodes([],[], Sums, Sols, GivenPath):-
	max_list(Sums, MaxValue),
	duration_critical_path(Sols,MaxValue, GivenPath).

get_critical_nodes([Sols|A], [Values|R],SumLists, Lis, GivenPath):-
	reverse(Sols, RevList),
	append([Values], RevList, NewRevList),
	append(Lis, [NewRevList], JList),	
	get_critical_nodes(A,R,SumLists, JList, GivenPath).


% popping value from stack
pop_critical_node([], R, Sols, GivenPath):-
	get_critical_nodes(Sols, R,R, [], GivenPath).

pop_critical_node([RR|R], Test, Sols, GivenPath):-
	pop_critical_node([], R, Sols, GivenPath).

crit_path_sum([],Sols, Sum, GivenPath):-
	flatten(Sum, R),
	pop_critical_node(R, [], Sols, GivenPath).
	
crit_path_sum([H|T],Revs, Arr, GivenPath):-
	get_cric_pathsum(H, Sum, GivenPath),
	crit_path_sum(T,Revs,[Arr,Sum], GivenPath).


% calculate path durations
get_cric_pathsum([], 0, GivenPath).
get_cric_pathsum([H|T], Sum, GivenPath) :-
	get_cric_pathsum(T, Rest, GivenPath),
	duration(H, X),
	Sum is X + Rest.


% get paths for start and finish nodes
generate_paths(Start, Destination, Path) :-
    generate_paths(Start, Destination, [], Path).
	generate_paths(Start, Start, _ , [Start]).
	generate_paths(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Start, Node),
	    generate_paths(Node, Destination, [Start|Visited], Nodes).

criticalPath(Prereq, Task, GivenPath) :-
	prerequisite(Prereq, X),
	criticalPath(X, Task, GivenPath).
	
criticalPath(Prereq, Task, GivenPath) :-
	\+ prerequisite(Prereq, X),
	findall(Path, generate_paths(Task, Prereq, Path), Sols),
	crit_path_sum(Sols, Sols, 0, GivenPath).