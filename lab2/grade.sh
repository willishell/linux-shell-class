#!/bin/bash

source config.sh

RESULTS="results/results.csv"
mkdir -p results
echo "student,task,score" > $RESULTS

for student_dir in submissions/*; do
    student=$(basename "$student_dir")
    [ "$student" = "teacher" ] && continue

    for task in "${TASKS[@]}"; do
        script="$student_dir/$task.sh"
        input="test_cases/$task.in"
        expected="test_cases/$task.out"
        output="tmp.out"

        if [ ! -f "$script" ]; then
            echo "$student,$task,0" >> $RESULTS
            continue
        fi

        chmod +x "$script"

        timeout $TIMEOUT bash "$script" < "$input" > "$output" 2>/dev/null

        if diff -q "$output" "$expected" >/dev/null; then
            echo "$student,$task,1" >> $RESULTS
        else
            echo "$student,$task,0" >> $RESULTS
        fi
    done
done

echo "Grading completed."
