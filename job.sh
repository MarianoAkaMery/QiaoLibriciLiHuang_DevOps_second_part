#!/bin/bash
#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output.log
#SBATCH --error=grayscale_output.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --partition=g100_all_serial

module load singularity
export TMPDIR=~/tmp
mkdir -p $TMPDIR
export SINGULARITY_TMPDIR=$TMPDIR/singularity_tmp
export SINGULARITY_CACHEDIR=$TMPDIR/singularity_cache
mkdir -p $SINGULARITY_TMPDIR $SINGULARITY_CACHEDIR

# Rebuild Singularity image inside Galileo
rm -f grayscale.sif
singularity build grayscale.sif Singularity.def

# Run your tests inside the container
echo "Running grayscale conversion..."
singularity exec grayscale.sif /opt/app/build/convert_grayscale input output Average

echo "Running grayscale tests..."
singularity exec grayscale.sif /opt/app/build/test_grayscale
