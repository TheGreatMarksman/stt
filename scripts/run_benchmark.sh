#!/bin/bash

# export BENCHMARKS=/data/home/jjb/InvisiSpec-1.0/microbenchmark
# export LD_LIBRARY_PATH=/data/home/jjb/miniconda/envs/py27/lib

# Validate required environment variables
if [ -z ${GEM5_PATH+x} ]; then
    echo "GEM5_PATH is unset"; exit 1
fi
# if [ -z ${BENCHMARKS+x} ]; then
#     echo "BENCHMARKS is unset"; exit 1
# fi
if [[ "$#" != 3 ]]; then
    echo "USAGE: run_benchmark.sh <BENCHMARK> <THREAT_MODEL> <STT_VALUE>"
    echo "EXAMPLE: ./run_benchmark.sh CCa Spectre 1"
    exit 1
fi

BENCHMARK=$1
THREAT_MODEL=$2

# Validate benchmark exists
BENCH_BINARY=$BENCHMARKS/$BENCHMARK/bench.X86
if [ ! -f "$BENCH_BINARY" ]; then
    echo "Error: benchmark binary not found at $BENCH_BINARY"
    exit 1
fi

OUTPUT_DIR=$GEM5_PATH/output/$BENCHMARK/$THREAT_MODEL/STT_$STT_VALUE
if [ -d "$OUTPUT_DIR" ]; then
    rm -r $OUTPUT_DIR
fi
mkdir -p $OUTPUT_DIR

echo "GEM5_PATH:   $GEM5_PATH"
echo "BENCHMARK:   $BENCHMARK"
# echo "BINARY:      $BENCH_BINARY"
echo "THREAT_MODEL:      $THREAT_MODEL"
echo "STT_VALUE:      $STT_VALUE"
echo "OUTPUT_DIR:  $OUTPUT_DIR"

$GEM5_PATH/build/X86_MESI_Two_Level/gem5.opt \
    --outdir=$OUTPUT_DIR \
    $GEM5_PATH/configs/example/se.py \
    --cmd=$BENCH_BINARY \
    --num-cpus=1 --mem-size=4GB \
    --l1d_assoc=8 --l2_assoc=16 --l1i_assoc=4 \
    --cpu-type=DerivO3CPU --needsTSO=0 --THREAT_MODEL=$THREAT_MODEL \
    --num-dirs=1 --ruby --maxinsts=2000000000\
    --network=simple --topology=Mesh_XY --mesh-rows=1 \
    | tee $OUTPUT_DIR/runscript.log