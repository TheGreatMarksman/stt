#!/bin/bash

BENCHMARKS=("CCa" "CCl" "DP1f" "ED1" "EI" "MI")
THREAT_MODEL=("UnsafeBaseline" "Spectre" "Futuristic")

for BENCHMARK in "${BENCHMARKS[@]}"; do
    for THREAT in "${THREAT_MODEL[@]}"; do
        echo "Running $BENCHMARK with threat model $THREAT..."
        ./scripts/run_benchmark.sh "$BENCHMARK" "$THREAT" &`
    done
done
wait
echo "All simulations complete"