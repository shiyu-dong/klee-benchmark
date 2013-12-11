rm -rf klee-out-* klee-last
if [ "$1" != "--clean" ]
then

  # compile program with gcov profiling
  gcc -L ../../Release+Asserts/lib $1.c -lkleeRuntest -fprofile-arcs -ftest-coverage -o $1

  # without optimization
  echo "=============================================="
  echo "no optimization "
  echo "=============================================="
  ./run-a-test.sh $1
  klee-stats --print-all klee-last

  TEST=$(find ./klee-last/ -name *.ktest)
  rm -rf *.gcda
  for test_case in ${TEST}
  do
    KTEST_FILE=${test_case} ./$1
  done
  gcov -b -c $1

  # with original klee optimization
  echo "=============================================="
  echo "original optimization "
  echo "=============================================="
  ./run-a-test.sh $1 --optimize
  klee-stats --print-all klee-last

  TEST=$(find ./klee-last/ -name *.ktest)
  rm -rf *.gcda
  for test_case in ${TEST}
  do
    KTEST_FILE=${test_case} ./$1
  done
  gcov -b -c $1

  # with one opt-flag
  for OPT in \
    AggressiveDCE \
    ArgumentPromotion \
    CFGSimplification \
    CondPropagation \
    ConstantMerge \
    DeadArgElimination \
    DeadStoreElimination \
    DeadTypeElimination \
    FunctionAttrs \
    FunctionInlining \
    GlobalDCE \
    GlobalOptimizer \
    GVN \
    IndVarSimplify \
    InstructionCombining \
    IPConstantPropagation \
    JumpThreading \
    LICM \
    LoopDeletion \
    LoopIndexSplit \
    LoopRotate \
    LoopUnroll \
    LoopUnswitch \
    MemCpyOpt \
    PromoteMemoryToRegister \
    PruneEH \
    RaiseAllocation \
    Reassociate \
    ScalarReplAggregates \
    SCCP \
    SimplifyLibCalls \
    StripDeadPrototypes \
    TailCallElimination
  do
    echo "=============================================="
    echo "with optimization flag "${OPT}
    echo "=============================================="
    ./run-a-test.sh $1 --optimize --opt-flag=${OPT}
    klee-stats --print-all klee-last

    TEST=$(find ./klee-last/ -name *.ktest)
    rm -rf *.gcda
    for test_case in ${TEST}
    do
      KTEST_FILE=${test_case} ./$1
    done
    gcov -b -c $1

  done
fi
