#!/bin/bash
set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$root_dir"

usage() {
    cat <<EOF
Usage: $0 [lab_dir_or_name] [student_id_file.csv]

Grade a lab from the project root without using any lab subdirectory grade.sh.
- If lab_dir_or_name is provided, grades only that lab.
- If student_id_file.csv is provided, uses only that CSV file.
- If no id file is provided, uses all CSV files from id/.
- If no lab is provided, grades every lab under the root.
EOF
    exit 1
}

lab_arg=""
selected_id_file=""

if [ "$#" -gt 2 ]; then
    usage
fi

if [ "$#" -eq 2 ]; then
    lab_arg=$1
    selected_id_file=$2
    if [ ! -d "$root_dir/$lab_arg" ] || [[ "$(basename "$lab_arg")" != lab* ]]; then
        echo "Error: lab directory '$lab_arg' not found under root." >&2
        exit 1
    fi
    if [ ! -f "$selected_id_file" ]; then
        echo "Error: student id file '$selected_id_file' not found." >&2
        exit 1
    fi
elif [ "$#" -eq 1 ]; then
    if [ -d "$root_dir/$1" ] && [[ "$(basename "$1")" == lab* ]]; then
        lab_arg=$1
    elif [ -f "$1" ]; then
        selected_id_file=$1
    else
        usage
    fi
fi

id_dir="$root_dir/id"
if [ -z "$selected_id_file" ] && [ ! -d "$id_dir" ]; then
    echo "Error: id directory '$id_dir' not found." >&2
    exit 1
fi

shopt -s nullglob

grade_lab() {
    local lab_dir="$1"
    local lab_name lab_number
    lab_name=$(basename "$lab_dir")
    lab_number=${lab_name#lab}

    echo "=== Grading $lab_name ==="

    if [ ! -f "$lab_dir/config.sh" ]; then
        echo "Warning: missing config.sh in $lab_dir, skipping." >&2
        return
    fi

    source "$lab_dir/config.sh"

    local teacher_dir="$lab_dir/submissions/teacher"
    if [ -d "$teacher_dir" ]; then
        echo "Generating standard answers from teacher scripts if missing..."
        for task in "${TASKS[@]}"; do
            local teacher_script="$teacher_dir/$task.sh"
            local input_file="$lab_dir/test_cases/${task}.in"
            local expected_file="$lab_dir/test_cases/${task}.out"
            if [ -f "$expected_file" ]; then
                continue
            fi
            if [ ! -f "$teacher_script" ]; then
                echo "Warning: teacher script $teacher_script not found, skipping generation for $task." >&2
                continue
            fi
            if [ ! -f "$input_file" ]; then
                echo "Warning: input file $input_file not found, skipping generation for $task." >&2
                continue
            fi
            timeout "$timeout_value" bash "$teacher_script" < "$input_file" > "$expected_file" 2>/dev/null
        done
    fi

    local timeout_value
    if [ -n "${TIMEOUT:-}" ]; then
        timeout_value="$TIMEOUT"
    elif [ -n "${TIME_LIMIT:-}" ]; then
        timeout_value="$TIME_LIMIT"
    else
        timeout_value=5
    fi

    local is_weighted=0
    if [ -n "${WEIGHTS:-}" ]; then
        is_weighted=1
    fi

    local csv_files=()
    if [ -n "$selected_id_file" ]; then
        csv_files=("$selected_id_file")
    else
        csv_files=("$id_dir"/*.csv)
    fi

    if [ "${#csv_files[@]}" -eq 0 ]; then
        echo "Warning: no id files found for $lab_name, skipping." >&2
        return
    fi

    local results_dir="$lab_dir/results"
    mkdir -p "$results_dir"

    local header="student_id,student_name"
    for task in "${TASKS[@]}"; do
        header+=",$task"
    done
    header+=",total,score"

    for class_csv in "${csv_files[@]}"; do
        local class_name
        class_name=$(basename "$class_csv" .csv)
        local results_file="$results_dir/${lab_name}_class${class_name}.csv"
        echo "$header" > "$results_file"

        while IFS=, read -r student_id student_name || [ -n "$student_id" ]; do
            student_id=${student_id//$'\r'/}
            student_name=${student_name//$'\r'/}
            if [ -z "$student_id" ]; then
                continue
            fi

            local student_lab="/home/$student_id/labs/$lab_name"
            if [ -d "$student_lab/$lab_name" ]; then
                student_lab="$student_lab/$lab_name"
            fi

            local row="$student_id,$student_name"
            local total_score=0
            local task_count=0

            for task in "${TASKS[@]}"; do
                task_count=$((task_count + 1))
                local script="$student_lab/$task.sh"
                local task_score=0

                if [ -f "$script" ]; then
                    local input_file expected_file output_file
                    if [ "$is_weighted" -eq 1 ]; then
                        local passed=0
                        local total=0
                        for input_file in "$lab_dir/test_cases/${task}"_*.in; do
                            expected_file="${input_file%.in}.out"
                            if [ ! -f "$expected_file" ]; then
                                continue
                            fi
                            total=$((total + 1))
                            output_file=$(mktemp)
                            if timeout "$timeout_value" bash "$script" < "$input_file" > "$output_file" 2>/dev/null && diff -q "$output_file" "$expected_file" >/dev/null; then
                                passed=$((passed + 1))
                            fi
                            rm -f "$output_file"
                        done
                        if [ "$total" -gt 0 ]; then
                            task_score=$((100 * passed / total))
                        else
                            task_score=0
                        fi
                    else
                        input_file="$lab_dir/test_cases/${task}.in"
                        expected_file="$lab_dir/test_cases/${task}.out"
                        if [ -f "$input_file" ] && [ -f "$expected_file" ]; then
                            output_file=$(mktemp)
                            if timeout "$timeout_value" bash "$script" < "$input_file" > "$output_file" 2>/dev/null && diff -q "$output_file" "$expected_file" >/dev/null; then
                                task_score=1
                            fi
                            rm -f "$output_file"
                        fi
                    fi
                fi

                if [ "$is_weighted" -eq 1 ]; then
                    local weight=0
                    if [ -n "${WEIGHTS[$task]:-}" ]; then
                        weight=${WEIGHTS[$task]}
                    fi
                    total_score=$((total_score + task_score * weight / 100))
                else
                    total_score=$((total_score + task_score))
                fi
                row+=",$task_score"
            done

            row+=",$total_score"
            if [ "$is_weighted" -eq 1 ]; then
                row+=",$total_score"
            else
                local percentage=0
                if [ "$task_count" -gt 0 ]; then
                    percentage=$((total_score * 100 / task_count))
                fi
                row+=",$percentage"
            fi
            echo "$row" >> "$results_file"
        done < "$class_csv"
    done

    echo "Saved results to $results_dir."
}

lab_dirs=("$root_dir"/lab*)
if [ -n "$lab_arg" ]; then
    lab_dirs=("$root_dir/$lab_arg")
fi

for lab_dir in "${lab_dirs[@]}"; do
    if [ -d "$lab_dir" ]; then
        grade_lab "$lab_dir"
    fi
done

if [ -n "$selected_id_file" ]; then
    echo "Done grading with student id file '$selected_id_file'."
else
    echo "Done grading with all id files in '$id_dir'."
fi
