#!/bin/bash
TIME_LIMIT=5
DIFF_OPTS="-w -B"

declare -A WEIGHTS
WEIGHTS[task1]=20
WEIGHTS[task2]=20
WEIGHTS[task3]=20
WEIGHTS[task4]=20
WEIGHTS[task5]=20

TASKS=("task1" "task2" "task3" "task4" "task5")

TEST_DIR="./test_cases"
SUBMISSIONS_DIR="./submissions"
SANDBOX_DIR="./sandbox"
RESULTS_FILE="./results/results.csv"
