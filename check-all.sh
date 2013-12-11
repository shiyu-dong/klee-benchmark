#!/bin/bash
PROGRAMS="ex2 ex3 ex8 ex9 ex20 ex30 ex34 ex40"

if [ "$1" == "--clean" ]
then
  make clean
  rm -rf klee-* *.gcno *.gcda *.gcov ex? ex?? test_result_new csv
else
  make
  if [ ! -d "test_result_new" ]; then
    mkdir test_result_new
  fi
  for program in $PROGRAMS
  do
    echo $program
    ./compare-all.sh $program &> test_result_new/result_$program.txt
  done
fi
