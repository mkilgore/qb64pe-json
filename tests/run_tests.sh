#!/bin/bash
# Arg 1: qb54 location

RESULTS_DIR="./tests/results/$PREFIX"

mkdir -p $RESULTS_DIR

QB64=$1

if [ "$#" -eq 2 ]; then
    CATEGORY="/$2"
fi

show_failure()
{
    cat "$RESULTS_DIR/$1-compile_result.txt"
}

show_incorrect_result()
{
    printf "EXPECTED: '%s'\n" "$1"
    printf "GOT:      '%s'\n" "$2"
}

PREFIX=bas

# Each .bas file represents a separate test.
for test in ./tests/bas/*.bas
do 
    testName=$(basename "$test" .bas)

    TESTCASE="$testName"
    EXE="$RESULTS_DIR/$testName-output"

    if [ "$OS" == "win" ]; then
        EXE="$EXE.exe"
    fi

    # Clean up existing EXE, so we don't use it by accident
    rm -f "$EXE*"

    compileResultOutput="$RESULTS_DIR/$testName-compile_result.txt"

    # -m and -q make sure that we get predictable results
    "$QB64" -q -m -x "./tests/bas/$testName.bas" -o "$EXE" 1>"$compileResultOutput"
    ERR=$?

    (exit $ERR)
    assert_success_named "Compile" "Compilation Error:" show_failure "$testName"

    test -f "$EXE"
    assert_success_named "exe exists" "$test-output executable does not exist!" show_failure "$testName"

    # Some tests do not have an output or err file because they should
    # compile successfully but cannot be run on the build agents
    if [ ! -f "./tests/bas/$testName.output" ]; then
        continue
    fi

    expectedResult="$(cat "./tests/bas/$testName.output")"

    testResult=$("$EXE" "$RESULTS_DIR" "$testName" 2>&1)
    assert_success_named "run" "Execution Error:" echo "$testResult"

    [ "$testResult" == "$expectedResult" ]
    assert_success_named "result" "Result is wrong:" show_incorrect_result "$expectedResult" "$testResult"
done
