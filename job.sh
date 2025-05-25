#!/bin/bash
#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --partition=g100_all_serial

module load singularity

# optional: keep Singularity scratch off the Lustre metadata servers
export TMPDIR="${HOME}/tmp"
mkdir -p "${TMPDIR}"
export SINGULARITY_TMPDIR="${TMPDIR}/singularity_tmp"
export SINGULARITY_CACHEDIR="${TMPDIR}/singularity_cache"
mkdir -p "${SINGULARITY_TMPDIR}" "${SINGULARITY_CACHEDIR}"

echo "Running grayscale conversion…"
singularity run grayscale.sif input output Average \
  || { echo "❌  Conversion failed"; exit 1; }

echo "Running unit tests…"
singularity exec grayscale.sif /tmp/grayscale_build/build/test_grayscale \
  || { echo "❌  Tests failed"; exit 2; }

echo "✅  All good!"
