#!/bin/bash
PROGRAMS="ex2 ex3 ex8 ex9 ex20 ex30 ex34"

for program in $PROGRAMS
do
  ./get-result-local-search.py test_result_new/result_$program.txt
done
