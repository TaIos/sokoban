#!/bin/bash
while read solver; do
	python ../downward/fast-downward.py --alias ${solver} --sas-file plans/${solver}.sas --search-time-limit 30m domain.pddl task.pddl
done <solvers_list.txt
