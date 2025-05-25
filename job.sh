#!/bin/bash
#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output.log
#SBATCH --error=grayscale_output.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --partition=g100_all_serial

module load singularity

# Fast scratch + Singularity cache
export TMPDIR=$HOME/tmp
export SINGULARITY_TMPDIR=$TMPDIR/singularity_tmp
export SINGULARITY_CACHEDIR=$TMPDIR/singularity_cache
mkdir -p "$SINGULARITY_TMPDIR" "$SINGULARITY_CACHEDIR"

echo "✅ SINGULARITY_TMPDIR = $SINGULARITY_TMPDIR"
echo "✅ SINGULARITY_CACHEDIR = $SINGULARITY_CACHEDIR"

echo "🚀 Running grayscale conversion…"
singularity exec grayscale.sif \
    /opt/app/build/convert_grayscale input output Average \
    >> grayscale_output.log 2>&1

echo "🧪 Running unit tests …"
singularity exec grayscale.sif \
    /opt/app/build/test_grayscale \
    >> grayscale_output.log 2>&1
