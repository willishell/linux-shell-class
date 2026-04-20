#!/bin/bash
set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/config.sh"

lab_dir=$(basename "$script_dir")
if [[ "$lab_dir" != lab* ]]; then
    echo "Error: script must be placed in a labN directory." >&2
    exit 1
fi
lab_number=${lab_dir#lab}

id_dir="$script_dir/../id"
if [ ! -d "$id_dir" ]; then
    echo "Error: id directory not found at $id_dir" >&2
    exit 1
fi

results_dir="$script_dir/results"
mkdir -p "$results_dir"

teacher_dir="$script_dir/submissions/teacher"
if [ -d "$teacher_dir" ]; then
    echo "Generating standard answers from teacher scripts..."
    for task in "${TASKS[@]}"; do
        teacher_script="$teacher_dir/$task.sh"
        input_file="$script_dir/test_cases/${task}.in"
        expected_file="$script_dir/test_cases/${task}.out"

        if [ ! -f "$teacher_script" ]; then
            echo "Warning: teacher script $teacher_script not found, skipping $task." >&2
            continue
        fi

        if [ ! -f "$input_file" ]; then
            echo "Warning: input file $input_file not found, skipping $task." >&2
            continue
        fi

        timeout "$TIMEOUT" bash "$teacher_script" < "$input_file" > "$expected_file" 2>/dev/null
    done
else
    echo "Warning: teacher submissions directory $teacher_dir not found, using existing expected outputs if present." >&2
fi

header="student_id,student_name"
for task in "${TASKS[@]}"; do
    header+=",$task"
done
header+=",total,score"

for class_csv in "$id_dir"/*.csv; do
    class_name=$(basename "$class_csv" .csv)
    results_file="$results_dir/lab${lab_number}_class${class_name}.csv"

    echo "$header" > "$results_file"

    while IFS=, read -r student_id student_name || [ -n "$student_id" ]; do
        student_id=${student_id//$'\r'/}
        student_name=${student_name//$'\r'/}

        if [ -z "$student_id" ]; then
            continue
        fi

        student_lab="/home/$student_id/labs/lab${lab_number}"
        if [ -d "$student_lab/lab${lab_number}" ]; then
            student_lab="$student_lab/lab${lab_number}"
        fi

        row="$student_id,$student_name"
        total_score=0

        for task in "${TASKS[@]}"; do
            script="$student_lab/$task.sh"
            score=0

            if [ -f "$script" ]; then
                output_file="$(mktemp)"

                if timeout "$TIMEOUT" bash "$script" < "$script_dir/test_cases/${task}.in" > "$output_file" 2>/dev/null && diff -q "$output_file" "$script_dir/test_cases/${task}.out" >/dev/null; then
                    score=1
                fi

                rm -f "$output_file"
            fi

            row+=",$score"
            total_score=$((total_score + score))
        done

        row+=",$total_score"
        score=$((total_score * 100 / ${#TASKS[@]}))
        row+=",$score"
        echo "$row" >> "$results_file"
    done < "$class_csv"
done

echo "Grading completed. Results saved to $results_dir."