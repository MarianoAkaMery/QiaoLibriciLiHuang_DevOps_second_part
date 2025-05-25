#!/bin/bash

#SBATCH --job-name=grayscale_job
#SBATCH --output=grayscale_output.log
#SBATCH --error=grayscale_output.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --partition=g100_all_serial

# Load Singularity
module load singularity

# Avoid "No Protocol specified" warning
export HWLOC_COMPONENTS=-gl

# Set up temporary directories
export TMPDIR=~/tmp
mkdir -p $TMPDIR
export OMPI_MCA_tmpdir_base=$TMPDIR
export OMPI_MCA_orte_tmpdir_base=$TMPDIR
export OMPI_MCA_plm_rsh_agent="ssh :rsh"
export OMPI_MCA_btl=self,tcp

# Singularity cache directories
export SINGULARITY_TMPDIR=$TMPDIR/singularity_tmp
export SINGULARITY_CACHEDIR=$TMPDIR/singularity_cache
mkdir -p $SINGULARITY_TMPDIR $SINGULARITY_CACHEDIR

# -------------------------
# Run grayscale conversion
# -------------------------
echo "Running grayscale conversion..." >> grayscale_output.log
singularity exec ./grayscale.sif /opt/app/build/convert_grayscale input output Average >> grayscale_output.log 2>&1

# -------------------------
# Run tests
# -------------------------
echo "Running grayscale tests..." >> grayscale_output.log
singularity exec ./grayscale.sif /opt/app/build/test_grayscale >> grayscale_output.log 2>&1
