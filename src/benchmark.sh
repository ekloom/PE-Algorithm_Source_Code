#!/usr/bin/env bash

OUTPUT_DIR="benchmark_results"
WARMUP_RUNS=100
RUNS=50
SUMMARY_CSV="$OUTPUT_DIR/benchmark_summary.csv"

mkdir -p "$OUTPUT_DIR"

declare -A dataset_types
dataset_types["Sorted"]="Sorted_10K Sorted_50K Sorted_100K Sorted_500K Sorted_1M"
dataset_types["ReverseSorted"]="Reverse_10K Reverse_50K Reverse_100K Reverse_500K Reverse_1M"
dataset_types["NearlySorted"]="NearlySorted_10K NearlySorted_50K NearlySorted_100K NearlySorted_500K NearlySorted_1M"
dataset_types["UniformSorted"]="Uniform_10K Uniform_50K Uniform_100K Uniform_500K Uniform_1M"
dataset_types["FewUnique"]="FewUnique_10K FewUnique_50K FewUnique_100K FewUnique_500K FewUnique_1M"

init_summary_csv() {
    if [ ! -f "$SUMMARY_CSV" ]; then
        echo "language,algorithm,dataset_type,variant,mean_seconds,stddev_seconds,min_seconds,max_seconds,peak_memory_kb,runs,warmup_runs" > "$SUMMARY_CSV"
    fi
}

get_script_name() {
    local language=$1
    local algorithm=$2
    local mode=$3

    if [ "$mode" = "benchmark" ]; then
        if [ "$language" = "python" ]; then
            echo "${algorithm}.py"
        else
            echo "${algorithm}.lua"
        fi
    else
        if [ "$language" = "python" ]; then
            echo "${algorithm}_instrumented.py"
        else
            echo "${algorithm}_instrumented.lua"
        fi
    fi
}

get_command() {
    local language=$1
    local algorithm=$2
    local file=$3
    local mode=$4
    local script

    script=$(get_script_name "$language" "$algorithm" "$mode")

    if [ "$language" = "python" ]; then
        echo "python3 ${script} < \"$file\""
    else
        echo "lua ${script} < \"$file\""
    fi
}

measure_peak_memory() {
    local language=$1
    local algorithm=$2
    local file=$3
    local mode=$4
    local cmd

    cmd=$(get_command "$language" "$algorithm" "$file" "$mode")
    /usr/bin/time -f "%M" bash -c "$cmd" 2>&1 >/dev/null
}

append_benchmark_csv_row() {
    local json_file=$1
    local language=$2
    local algorithm=$3
    local dataset_type=$4
    local variant=$5
    local peak_mem=$6

    python3 - "$json_file" "$SUMMARY_CSV" "$language" "$algorithm" "$dataset_type" "$variant" "$peak_mem" "$RUNS" "$WARMUP_RUNS" <<'PY'
import csv
import json
import sys

json_file = sys.argv[1]
summary_csv = sys.argv[2]
language = sys.argv[3]
algorithm = sys.argv[4]
dataset_type = sys.argv[5]
variant = sys.argv[6]
peak_mem = sys.argv[7]
runs = sys.argv[8]
warmup_runs = sys.argv[9]

with open(json_file, "r", encoding="utf-8") as f:
    data = json.load(f)

result = data["results"][0]

row = [
    language,
    algorithm,
    dataset_type,
    variant,
    result["mean"],
    result["stddev"],
    result["min"],
    result["max"],
    peak_mem,
    runs,
    warmup_runs,
]

with open(summary_csv, "a", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(row)
PY
}

run_benchmark() {
    local language=$1
    local dataset_type=$2
    local algorithm=$3

    init_summary_csv

    for variant in ${dataset_types[$dataset_type]}; do
        local file="Data/${variant}.txt"
        local json_file="$OUTPUT_DIR/${language}_${algorithm}_${variant}.json"
        local peak_mem
        local cmd

        if [ ! -f "$file" ]; then
            echo "Error: missing file: $file" >&2
            exit 1
        fi

        cmd=$(get_command "$language" "$algorithm" "$file" "benchmark")
        peak_mem=$(measure_peak_memory "$language" "$algorithm" "$file" "benchmark")

        echo "Benchmarking $language | $algorithm | $variant"

if hyperfine \
    --warmup "$WARMUP_RUNS" \
    --runs "$RUNS" \
    --export-json "$json_file" \
    "$cmd"
then
    append_benchmark_csv_row "$json_file" "$language" "$algorithm" "$dataset_type" "$variant" "$peak_mem"
    echo "Saved summary row for $language | $algorithm | $variant"
else
    echo "Error: benchmark failed for $language | $algorithm | $variant" >&2
    exit 1
fi
    done
}

run_instrumented() {
    local language=$1
    local dataset_type=$2
    local algorithm=$3

    for variant in ${dataset_types[$dataset_type]}; do
        local file="Data/${variant}.txt"
        local txt_file="$OUTPUT_DIR/${language}_${algorithm}_${variant}_instrumented.txt"
        local cmd

        if [ ! -f "$file" ]; then
            echo "Error: missing file: $file" >&2
            exit 1
        fi

        cmd=$(get_command "$language" "$algorithm" "$file" "instrumented")

        echo "Instrumented run: $language | $algorithm | $variant" > "$txt_file"

        for ((i=1; i<=WARMUP_RUNS; i++)); do
            bash -c "$cmd" >/dev/null
        done

        for ((i=1; i<=RUNS; i++)); do
            echo "Run $i:" >> "$txt_file"
            bash -c "$cmd" >> "$txt_file"
            echo "" >> "$txt_file"
        done

        echo "Saved: $txt_file"
    done
}

run_for_selection() {
    local target=$1
    local mode=$2
    local dataset_type=$3
    local algorithm=$4

    case "$target" in
        python)
            if [ "$mode" = "benchmark" ]; then
                run_benchmark "python" "$dataset_type" "$algorithm"
            else
                run_instrumented "python" "$dataset_type" "$algorithm"
            fi
            ;;
        lua)
            if [ "$mode" = "benchmark" ]; then
                run_benchmark "lua" "$dataset_type" "$algorithm"
            else
                run_instrumented "lua" "$dataset_type" "$algorithm"
            fi
            ;;
        both)
            if [ "$mode" = "benchmark" ]; then
                run_benchmark "python" "$dataset_type" "$algorithm"
                run_benchmark "lua" "$dataset_type" "$algorithm"
            else
                run_instrumented "python" "$dataset_type" "$algorithm"
                run_instrumented "lua" "$dataset_type" "$algorithm"
            fi
            ;;
    esac
}

echo "Choose mode:"
echo "1) Benchmark (hyperfine + peak memory, uses normal files)"
echo "2) Instrumented (internal algorithm timings, uses instrumented files)"
read -rp "Enter choice (1 or 2): " mode_choice

case "$mode_choice" in
    1) mode="benchmark" ;;
    2) mode="instrumented" ;;
    *) echo "Invalid mode choice"; exit 1 ;;
esac

echo "Choose language:"
echo "1) Python"
echo "2) Lua"
echo "3) Both (sequential, not parallel)"
read -rp "Enter choice (1 to 3): " lang_choice

case "$lang_choice" in
    1) target="python" ;;
    2) target="lua" ;;
    3) target="both" ;;
    *) echo "Invalid language choice"; exit 1 ;;
esac

echo "Choose dataset type:"
echo "1) Sorted"
echo "2) ReverseSorted"
echo "3) NearlySorted"
echo "4) UniformSorted"
echo "5) FewUnique"
read -rp "Enter choice (1 to 5): " data_choice

case "$data_choice" in
    1) dataset_type="Sorted" ;;
    2) dataset_type="ReverseSorted" ;;
    3) dataset_type="NearlySorted" ;;
    4) dataset_type="UniformSorted" ;;
    5) dataset_type="FewUnique" ;;
    *) echo "Invalid dataset choice"; exit 1 ;;
esac

echo "Choose sorting algorithm:"
echo "1) Mergesort"
echo "2) Quicksort"
read -rp "Enter choice (1 or 2): " algo_choice

case "$algo_choice" in
    1) algorithm="mergesort" ;;
    2) algorithm="quicksort" ;;
    *) echo "Invalid algorithm choice"; exit 1 ;;
esac

run_for_selection "$target" "$mode" "$dataset_type" "$algorithm"

echo "Done. Results saved in $OUTPUT_DIR/"