#!/bin/bash
set -euo pipefail

RESULTS_DIR=$1
N_FILES=12

echo "Counting matches into summary matrix"

python 01_GitHub/scripts/build_matrix.py "$RESULTS_DIR"

echo "Matches matrix built"
