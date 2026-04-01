#!/bin/bash
source ./config.sh

shopt -s nullglob

mkdir -p "$SANDBOX_DIR"
mkdir -p "$(dirname "$RESULTS_FILE")"

echo "Student,task1,task2,task3,task4,task5,Total" > "$RESULTS_FILE"

for student_dir in "$SUBMISSIONS_DIR"/*; do
    student=$(basename "$student_dir")
    total_score=0
    row="$student"

    for task in "${TASKS[@]}"; do
        script="$student_dir/${task}.sh"
        weight=${WEIGHTS[$task]}

        if [ ! -f "$script" ]; then
            row="$row,0"
            continue
        fi

        passed=0
        total=0

        for input in "$TEST_DIR"/${task}_*.in; do
            expected="${input%.in}.out"
            total=$((total + 1))

            workdir="$SANDBOX_DIR/$student"
            rm -rf "$workdir"
            mkdir -p "$workdir"

            cp "$script" "$workdir/"
            chmod +x "$workdir/${task}.sh"

            output="$workdir/output.txt"

            test_input="$(< "$input")"
            if [ -f "$test_input" ]; then
                timeout $TIME_LIMIT bash "$workdir/${task}.sh" "$test_input" > "$output" 2>/dev/null
            else
                timeout $TIME_LIMIT bash "$workdir/${task}.sh" < "$input" > "$output" 2>/dev/null
            fi

            if [ $? -ne 0 ]; then
                continue
            fi

            sed -i 's/[[:space:]]*$//' "$output"

            if diff $DIFF_OPTS "$output" "$expected" >/dev/null; then
                passed=$((passed + 1))
            fi
        done

        if [ $total -eq 0 ]; then
            score=0
        else
            score=$((100 * passed / total))
        fi

        weighted=$((score * weight / 100))
        total_score=$((total_score + weighted))

        row="$row,$score"
    done

    row="$row,$total_score"
    echo "$row" >> "$RESULTS_FILE"
done

echo "Done. Results in $RESULTS_FILE"
