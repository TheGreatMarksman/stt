#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCHMARKS=("CCa" "CCl" "DP1f" "ED1" "EI" "MI")
THREAT_MODEL=("UnsafeBaseline" "Spectre" "Futuristic")
STT=(0 1)

for BENCHMARK in "${BENCHMARKS[@]}"; do
    # Make sure Benchmark is compiled
    make -C "$BASE_DIR/microbenchmark/$BENCHMARK" benchX86
    for THREAT in "${THREAT_MODEL[@]}"; do
        for STT_VALUE in "${STT[@]}"; do

            # STT cannot be 1 for UnsafeBaseline
            if [[ "$THREAT" == "UnsafeBaseline" && "$STT_VALUE" -eq 1 ]]; then
                echo "Skipping $BENCHMARK with $THREAT and STT=1 (invalid configuration)"
                continue
            fi

            echo "Running $BENCHMARK with threat model $THREAT and STT value $STT_VALUE..."
            "$BASE_DIR/scripts/run_benchmark.sh" "$BENCHMARK" "$THREAT" "$STT_VALUE" &
        done
    done
done
wait
echo "All simulations complete"