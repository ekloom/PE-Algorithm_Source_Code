#!/usr/bin/env bash

# Output directory for results
OUTPUT_DIR="benchmark_results"
RUNS=10
mkdir -p "$OUTPUT_DIR"

# Define dataset variants for each category as a space-separated string
declare -A dataset_types
dataset_types["Sorted"]="Sorted_10K Sorted_50K Sorted_100K Sorted_500K Sorted_1M"
dataset_types["ReverseSorted"]="Reverse_10K Reverse_50K Reverse_100K Reverse_500K Reverse_1M"
dataset_types["NearlySorted"]="NearlySorted_10K NearlySorted_50K NearlySorted_100K NearlySorted_500K NearlySorted_1M"
dataset_types["UniformSorted"]="Uniform_10K Uniform_50K Uniform_100K Uniform_500K Uniform_1M"
dataset_types["FewUnique"]="FewUnique_10K FewUnique_50K FewUnique_100K FewUnique_500K FewUnique_1M"

# Function to run the test
run_test () {
    local language=$1
    local dataset_type=$2
    local algorithm=$3
    output_file="$OUTPUT_DIR/${language}_${algorithm}_${dataset_type}_results.txt"

    # Initialize the output file
    echo "Benchmark results for $language - $algorithm - $dataset_type" > "$output_file"
    echo "=========================================" >> "$output_file"
    
    # Loop through dataset variants for the selected type
    for variant in ${dataset_types[$dataset_type]}; do
      file="Data/$variant.txt"
      
        if [ "$language" == "python" ]; then
		# Capture peak memory using /usr/bin/time
		peak_mem=$(/usr/bin/time -f "%M" python3 "$algorithm.py" < "$file" 2>&1 >/dev/null)
		elif [ "$language" == "lua" ]; then
    # Capture peak memory using /usr/bin/time
                peak_mem=$(/usr/bin/time -f "%M" lua "$algorithm.lua" < "$file" 2>&1 >/dev/null)
        fi

    {
        echo "===== $dataset_type | $variant ====="
        echo "Peak Memory: ${peak_mem} KB"
    } >> "$output_file"


    
        for ((i=1; i<=RUNS; i++)); do
       
  if [ "$language" == "python" ]; then
    run_output=$(python3 "$algorithm.py" < "$file")
    echo "Python output for $variant, Run $i: $run_output"
  elif [ "$language" == "lua" ]; then
    run_output=$(lua "$algorithm.lua" < "$file")
     echo "Lua output for $variant, Run $i: $run_output"
  fi

  # Write results to the output file (including both python and lua output)
  {
    echo "Run $i:"
    echo "$run_output"
    echo ""
  } >> "$output_file"
done
    done
}

# Select language
echo "Choose language:"
echo "1) Python"
echo "2) Lua"
read -rp "Enter choice (1 or 2): " lang_choice

case "$lang_choice" in
    1) language="python" ;;
    2) language="lua" ;;
    *) echo "Invalid language choice"; exit 1 ;;
esac

# Select dataset variant
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

# Select sorting algorithm
echo "Choose sorting algorithm:"
echo "1) Mergesort"
echo "2) Quicksort"
read -rp "Enter choice (1 or 2): " algo_choice

case "$algo_choice" in
    1) algorithm="mergesort" ;;
    2) algorithm="quicksort" ;;
    *) echo "Invalid algorithm choice"; exit 1 ;;
esac

# Run the benchmark for the selected options
run_test "$language" "$dataset_type" "$algorithm"

# Finished message
echo "Benchmark completed for '$language' with the algorithm '$algorithm' of dataset_type '$dataset_type'. Results saved in $OUTPUT_DIR as '$output_file' "
