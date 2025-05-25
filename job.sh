#!/bin/bash
#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output_%j.log   # one file per run
#SBATCH --error=grayscale_error_%j.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --partition=g100_all_serial

###############################################################################
# Tiny logging helper + defensive bash flags
set -euo pipefail
log () {                              # green lines inside SLURM output
    printf '\033[1;32m[%s] %s\033[0m\n' "$(date +'%F %T')" "$*"
}
[[ "${DEBUG_PIPE:-0}" == "1" ]] && set -x
trap 'log "Job finished with status $?"'  EXIT
###############################################################################

log "SLURM node      : $(hostname)"
log "CWD before  cd  : $(pwd)"
cd "$SLURM_SUBMIT_DIR"
log "CWD after   cd  : $(pwd)"

module load singularity
log "Singularity     : $(singularity --version)"

# keep Singularity tmp away from Lustre MDTs
export TMPDIR="${HOME}/tmp"
export SINGULARITY_TMPDIR="${TMPDIR}/singularity_tmp"
export SINGULARITY_CACHEDIR="${TMPDIR}/singularity_cache"
mkdir -p "${SINGULARITY_TMPDIR}" "${SINGULARITY_CACHEDIR}"

log "▶ Converting sample image …"
singularity run            \
  --bind "$PWD":"$PWD"     \
  --pwd  "$PWD"            \
  grayscale.sif input output Average \
  || { log "❌ Conversion failed"; exit 1; }

log "▶ Running unit tests …"
singularity exec           \
  --bind "$PWD":"$PWD"     \
  --pwd  "$PWD"            \
  grayscale.sif /tmp/grayscale_build/build/test_grayscale \
  || { log "❌ Tests failed"; exit 2; }

log "✅ All good!"
