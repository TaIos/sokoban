#!/bin/bash
rm -rf plans/*
while read solver; do
  #	t0=`date +%s`
  python ../downward/fast-downward.py --alias ${solver} --sas-file plans/${solver}.sas --search-time-limit 30m domain.pddl task.pddl >plans/${solver}.out 2>&1 &
  #	t1=`date +%s`
  #	runtime=$((t1-t0))
  #	echo $runtime > plans/${solver}.runtime
done <solvers_list.txt

wait
timestamp=$(date +%d-%m-%Y_%H-%M-%S)
cp -R plans/ plans_${timestamp}
