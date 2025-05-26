#!/bin/bash
#SBATCH --job-name=grayscale_job
#SBATCH --time=00:05:00          # alza se processi molte immagini
#SBATCH --mem=8G
#SBATCH --output=grayscale_output.log

# --- (solo se Galileo richiede il modulo) ------------------------------
module purge
module load singularity 2>/dev/null || true

# --- percorsi sul filesystem del nodo ----------------------------------
IN_HOST="$SCRATCH/seproject/images"      # cartella con le immagini INPUT
OUT_HOST="$SCRATCH/seproject/result"     # cartella per salvare l’OUTPUT
SIF="$HOME/seproject/grayscale.sif"      # container copiato dallo script CI

mkdir -p "$OUT_HOST"

# --- esegui il container montando le directory host ---------------------
singularity exec \
  --bind "${IN_HOST}:/data/input" \
  --bind "${OUT_HOST}:/data/output" \
  "$SIF" \
  /usr/local/bin/convert_grayscale /data/input /data/output Average
