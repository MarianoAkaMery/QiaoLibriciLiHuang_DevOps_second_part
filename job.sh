#!/bin/bash
#
#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output.log   # stdout & stderr together
#SBATCH --error=grayscale_output.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --partition=g100_all_serial

# ---------------------------------------------------------------------------
module load singularity

# personal scratch to keep Galileo’s /tmp clean
export TMPDIR="${HOME}/tmp"
mkdir -p "${TMPDIR}"

export SINGULARITY_TMPDIR="${TMPDIR}/singularity_tmp"
export SINGULARITY_CACHEDIR="${TMPDIR}/singularity_cache"
mkdir -p "${SINGULARITY_TMPDIR}" "${SINGULARITY_CACHEDIR}"

echo "Create tmp directory SINGULARITY_TMPDIR = ${SINGULARITY_TMPDIR}"
echo "Create cache directory SINGULARITY_CACHEDIR = ${SINGULARITY_CACHEDIR}"

# ---------------------------------------------------------------------------
echo "Running grayscale conversion…"
singularity run grayscale.sif input output Average || {
    echo "❌ Grayscale conversion failed"
    exit 1
}

echo "Running grayscale unit tests…"
singularity exec grayscale.sif /opt/app/build/test_grayscale || {
    echo "❌ Unit tests failed"
    exit 2
}

echo "✅ All done"
