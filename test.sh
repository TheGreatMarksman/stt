#!/bin/bash

BENCHMARKS=("CCa" "CCl" "DP1f" "ED1" "EI" "MI")
THREAT_MODEL=("UnsafeBaseline" "Spectre" "Futuristic")
STT=(0 1)

for BENCHMARK in "${BENCHMARKS[@]}"; do
    for THREAT in "${THREAT_MODEL[@]}"; do
        for STT_VALUE in "${STT[@]}"; do
            echo "Running $BENCHMARK with threat model $THREAT and STT value $STT_VALUE..."
            ./scripts/run_benchmark.sh "$BENCHMARK" "$THREAT" "$STT_VALUE" &
        done
    done
done
wait
echo "All simulations complete"