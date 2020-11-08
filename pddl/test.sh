#!/bin/bash
rm -rf plans/*
while read solver; do
	python ../downward/fast-downward.py --alias ${solver} --sas-file plans/${solver}.sas --search-time-limit 30m domain.pddl task.pddl > plans/${solver}.out 2>&1  &
done <solvers_list.txt
