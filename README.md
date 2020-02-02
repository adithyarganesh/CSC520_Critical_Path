# Coded format
The critical path includes both start and end node. Ie. critical path of d for instance may be [a,b,c,d]

# Brief
A prolog code is written to calculate the critical path, early start, maximum slack and latest start for nodes in a graph. I have written recursive functions to determine the sequential method to perform each task and the exit conditions for each condition have been added.

# Process
Consult the cide in prolog compiler and then run the described functions.

# Task
To implement and evaluate the critical path scheduling method in Prolog for arbitrary scheduling graphs.

# Description

Code implements the following the following predicates for testing without using the if-then construct:
criticalPath(<task>, <path>).
earlyFinish(<task>, <time>).
lateStart(<task>, <time>).
maxSlack(<task>, <time>).
The first of these should map to true if and only if <path> is an ordered list of the items in the critical
path to the designated task. The second must map true if and only if <time> is the earliest time that <task>
can complete in the schedule. The third should return true if and only if <time> is the latest that a <task>
can begin without delaying anything on the critical path. And the fourth should return true if and only
if <task> is the one known task with the most slack in the database and <time> is that amount of slack.
As always your code must be clear, readable, and well commented, and your own. Your nal report should
include diagrams of the test graphs with values for the early start, late start, and slack and the critical path
indicated.

# Given Params
duration(a, 10).
prerequisite(b, a).
