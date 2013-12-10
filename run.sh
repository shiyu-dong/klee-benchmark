if [ "$1" == "--clean" ]
then
  make clean
  rm -rf klee-* *.gcno *.gcda *.gcov ex? ex??
else
  make
  for PROGRAM in ex2 ex3 ex8 ex9 ex20 ex30 ex34
  do
    echo ${PROGRAM}
    # compile program with gcov profiling
    gcc -L ../../Release+Asserts/lib ${PROGRAM}.c -lkleeRuntest -fprofile-arcs -ftest-coverage -o ${PROGRAM}

    # run klee without optimization flag
    if [ "$1" == "--print" ]
    then
      klee-original --print-before-all --libc=uclibc ${PROGRAM}.bc
    else
      klee-original --libc=uclibc ${PROGRAM}.bc
    fi
    klee-stats --print-all klee-last
    # run all generated test cases
    TEST=$(find ./klee-last/ -name *.ktest)
    rm -rf ${PROGRAM}.gcda
    for test_case in ${TEST}
    do
      KTEST_FILE=${test_case} ./${PROGRAM}
    done
    gcov -b -c ${PROGRAM}

    # run klee with original optimization
    if [ "$1" == "--print" ]
    then
      klee-original --optimize --print-after-all --libc=uclibc ${PROGRAM}.bc
    else
      klee-original --optimize --libc=uclibc ${PROGRAM}.bc
    fi
    klee-stats --print-all klee-last
    # run all the generated test cases
    TEST=$(find ./klee-last/ -name *.ktest)
    rm -rf ${PROGRAM}.gcda
    for test_case in ${TEST}
    do
      KTEST_FILE=${test_case} ./${PROGRAM}
    done
    gcov -b -c ${PROGRAM}

    # # run klee with optimization flag
    # klee-flag --optimize -opt-flag=AggresiveDCE --libc=uclibc ${PROGRAM}.bc
    # klee-stats --print-all klee-last
    # # run all the generated test cases
    # TEST=$(find ./klee-last/ -name *.ktest)
    # rm -rf ${PROGRAM}.gcda
    # for test_case in ${TEST}
    # do
    #   KTEST_FILE=${test_case} ./${PROGRAM}
    # done
    # gcov -b -c ${PROGRAM}
  done
fi
