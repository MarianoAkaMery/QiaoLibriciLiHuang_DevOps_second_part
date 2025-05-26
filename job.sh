#!/bin/bash
#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output.log
#SBATCH --time=0:02:00
#SBATCH --ntasks=1
#SBATCH --partition=g100_all_serial

cd "$SLURM_SUBMIT_DIR"
module load singularity

# Keep Singularity’s tmp & cache off Lustre metadata servers
export TMPDIR="${HOME}/tmp"
mkdir -p "${TMPDIR}"
export SINGULARITY_TMPDIR="${TMPDIR}/singularity_tmp"
export SINGULARITY_CACHEDIR="${TMPDIR}/singularity_cache"
mkdir -p "${SINGULARITY_TMPDIR}" "${SINGULARITY_CACHEDIR}"

# Bind large scratch for I/O
export SCRATCH_DIR="${SCRATCH:-/scratch/${USER}}"
mkdir -p "${SCRATCH_DIR}"
BIND_OPT="--bind ${SCRATCH_DIR}:/data"

echo "Running grayscale conversion…"
singularity run ${BIND_OPT} grayscale.sif /data/input /data/output Average \
  || { echo "❌  Conversion failed"; exit 1; }

echo "Running unit tests…"
singularity exec ${BIND_OPT} grayscale.sif /opt/app/build/test_grayscale \
  || { echo "❌  Tests failed"; exit 2; }

echo "✅  All good!"
