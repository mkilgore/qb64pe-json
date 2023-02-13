#!/bin/bash
# Arg 1: qb54 location

PREFIX=json

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
    diff -y <(echo "$1") <(echo "$2")
}

JSON_DUMP="./tests/results/json/json_dump"

if [ "$OS" == "win" ]; then
    JSON_DUMP="$JSON_DUMP.exe"
fi
# "-f:OptimizeCppProgram=true" 
"$QB64" -q -m -x "./tests/json-dump.bas" -o "$JSON_DUMP" 1>"./tests/results/json/json_dump-compile_result.txt"
assert_success_named "Compile" "Compilation Error:" show_failure "json_dump"

# Each .json file represents a separate test.
for test in ./tests/json-tests/*.json
do 
    testName=$(basename "$test" .json)

    TESTCASE="$testName"
    OUTPUT="$RESULTS_DIR/$testName-output"

    # Clean up existing OUTPUT, so we don't use it by accident
    rm -f "$OUTPUT*"

    "$JSON_DUMP" "$test" > "$OUTPUT"

    testResult="$(cat "$OUTPUT")"
    expectedResult="$(cat "./tests/json-tests/$testName.output")"

    [ "$testResult" == "$expectedResult" ]
    assert_success_named "result" "Result is wrong:" show_incorrect_result "$expectedResult" "$testResult"
done
