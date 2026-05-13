#!/bin/bash
set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$root_dir"

usage() {
    cat <<EOF
Usage: $0 [-d|--debug-diff] [lab_dir_or_name] [student_id_file.csv]

Grade labs from the project root without using lab2+/grade.sh scripts.
- lab1 is not supported by this shared grader.
- -d, --debug-diff prints a unified diff when student output differs from teacher output.
- If lab_dir_or_name is provided, grades only that lab.
- If student_id_file.csv is provided, uses only that CSV file.
- If no id file is provided, uses all CSV files from id/.
- If no lab is provided, grades every supported lab under the root.
EOF
    exit 1
}

lab_arg=""
selected_id_file=""
debug_diff=0

args=()
while [ "$#" -gt 0 ]; do
    case "$1" in
        -d|--debug-diff)
            debug_diff=1
            ;;
        -h|--help)
            usage
            ;;
        --)
            shift
            while [ "$#" -gt 0 ]; do
                args+=("$1")
                shift
            done
            break
            ;;
        -*)
            echo "Error: unknown option '$1'." >&2
            usage
            ;;
        *)
            args+=("$1")
            ;;
    esac
    shift
done

set -- "${args[@]}"

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

build_diff_args() {
    if [ -n "${DIFF_OPTS:-}" ]; then
        read -r -a diff_args <<< "$DIFF_OPTS"
    else
        diff_args=(-w -B)
    fi
}

compare_outputs() {
    local actual_file="$1"
    local expected_file="$2"
    local mismatch_context="$3"

    if diff "${diff_args[@]}" "$actual_file" "$expected_file" >/dev/null; then
        return 0
    fi

    if [ "$debug_diff" -eq 1 ]; then
        echo "Output mismatch: $mismatch_context" >&2
        diff -u "${diff_args[@]}" \
            --label "student output" \
            --label "teacher output" \
            "$actual_file" "$expected_file" >&2 || true
        echo >&2
    fi

    return 1
}

run_script_with_input() {
    local script_path="$1"
    local input_file="$2"
    local output_file="$3"
    local timeout_value="$4"
    local working_dir="$5"

    (
        cd "$working_dir"
        timeout "$timeout_value" bash "$script_path" < "$input_file" > "$output_file" 2>/dev/null || true
    )
}

ensure_supported_lab() {
    local lab_name="$1"

    if [ "$lab_name" = "lab1" ]; then
        echo "Error: lab1 is not supported by the shared grader." >&2
        return 1
    fi

    return 0
}

grade_lab() {
    local lab_dir="$1"
    local lab_name lab_number
    lab_name=$(basename "$lab_dir")
    lab_number=${lab_name#lab}

    if ! ensure_supported_lab "$lab_name"; then
        return
    fi

    echo "=== Grading $lab_name ==="

    if [ ! -f "$lab_dir/config.sh" ]; then
        echo "Warning: missing config.sh in $lab_dir, skipping." >&2
        return
    fi

    source "$lab_dir/config.sh"

    local timeout_value
    if [ -n "${TIMEOUT:-}" ]; then
        timeout_value="$TIMEOUT"
    elif [ -n "${TIME_LIMIT:-}" ]; then
        timeout_value="$TIME_LIMIT"
    else
        timeout_value=5
    fi

    build_diff_args

    local teacher_dir="$lab_dir/submissions/teacher"
    if [ -d "$teacher_dir" ]; then
        echo "Generating standard answers from teacher scripts..."
        for task in "${TASKS[@]}"; do
            local teacher_script="$teacher_dir/$task.sh"
            local input_file="$lab_dir/test_cases/${task}.in"
            local expected_file="$lab_dir/test_cases/${task}.out"
            if [ ! -f "$teacher_script" ]; then
                echo "Warning: teacher script $teacher_script not found, skipping generation for $task." >&2
                continue
            fi
            if [ ! -f "$input_file" ]; then
                echo "Warning: input file $input_file not found, skipping generation for $task." >&2
                continue
            fi
            run_script_with_input "$teacher_script" "$input_file" "$expected_file" "$timeout_value" "$lab_dir"
        done
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

    echo "Grading student scripts..."

    local wrong_counts=()
    local total_students=0
    local task_index
    for task_index in "${!TASKS[@]}"; do
        wrong_counts[$task_index]=0
    done

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
            total_students=$((total_students + 1))

            for task_index in "${!TASKS[@]}"; do
                local task="${TASKS[$task_index]}"
                task_count=$((task_count + 1))
                local script="$student_lab/$task.sh"
                local task_score=0

                if [ -f "$script" ]; then
                    local input_file expected_file output_file
                    input_file="$lab_dir/test_cases/${task}.in"
                    expected_file="$lab_dir/test_cases/${task}.out"
                    if [ -f "$input_file" ] && [ -f "$expected_file" ]; then
                        output_file=$(mktemp)
                        run_script_with_input "$script" "$input_file" "$output_file" "$timeout_value" "$student_lab" || true
                        if compare_outputs "$output_file" "$expected_file" "$lab_name/$task student=$student_id"; then
                            task_score=1
                        fi
                        rm -f "$output_file"
                    fi
                fi

                if [ "$task_score" -eq 0 ]; then
                    wrong_counts[$task_index]=$((wrong_counts[$task_index] + 1))
                fi

                total_score=$((total_score + task_score))
                row+=",$task_score"
            done

            row+=",$total_score"
            local percentage=0
            if [ "$task_count" -gt 0 ]; then
                percentage=$((total_score * 100 / task_count))
            fi
            row+=",$percentage"
            echo "$row" >> "$results_file"
        done < "$class_csv"
    done

    local wrong_stats_file="$results_dir/${lab_name}_wrong_stats.csv"
    local wrong_stats_tmp
    wrong_stats_tmp=$(mktemp)
    for task_index in "${!TASKS[@]}"; do
        local task="${TASKS[$task_index]}"
        local wrong_count="${wrong_counts[$task_index]}"
        echo "$task,$wrong_count,$total_students" >> "$wrong_stats_tmp"
    done

    {
        echo "task,wrong_count,total_students"
        sort -t, -k2,2nr -k1,1 "$wrong_stats_tmp"
    } > "$wrong_stats_file"
    rm -f "$wrong_stats_tmp"

    echo "Wrong answer statistics for $lab_name:"
    if command -v column >/dev/null 2>&1; then
        column -s, -t "$wrong_stats_file"
    else
        cat "$wrong_stats_file"
    fi
    echo "Saved results to $results_dir."
}

lab_dirs=("$root_dir"/lab*)
if [ -n "$lab_arg" ]; then
    ensure_supported_lab "$(basename "$lab_arg")" || exit 1
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
