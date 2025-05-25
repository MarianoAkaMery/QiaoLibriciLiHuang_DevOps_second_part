#!/bin/bash
#
#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output.log     # stdout + stderr → one file
#SBATCH --error=grayscale_output.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --partition=g100_all_serial       # serial queue on Galileo100

module load singularity

# ---------- scratch / cache setup -------------------------------------------
export TMPDIR="${HOME}/tmp"
mkdir -p "$TMPDIR"

export SINGULARITY_TMPDIR="$TMPDIR/singularity_tmp"
export SINGULARITY_CACHEDIR="$TMPDIR/singularity_cache"
mkdir -p "$SINGULARITY_TMPDIR" "$SINGULARITY_CACHEDIR"

echo "✅  SINGULARITY_TMPDIR  = $SINGULARITY_TMPDIR"
echo "✅  SINGULARITY_CACHEDIR = $SINGULARITY_CACHEDIR"
echo "------------------------------------------------------------------"

# ---------- 1. build-if-needed *and* run the converter -----------------------
echo "🚀  Building (if required) *and* running grayscale conversion ..."
# 'singularity run' invokes the %runscript in the SIF, which:
#   • copies the fresh sources into /opt/app
#   • runs build.sh
#   • then executes convert_grayscale
singularity run grayscale.sif input output Average

# ---------- 2. run unit tests inside the same image --------------------------
echo "🧪  Running unit tests ..."
singularity exec grayscale.sif /opt/app/build/test_grayscale

echo "✅  Job finished"
