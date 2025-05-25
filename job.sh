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

export OMPI_MCA_tmpdir_base=$TMPDIR
export OMPI_MCA_orte_tmpdir_base=$TMPDIR
export OMPI_MCA_plm_rsh_agent="ssh :rsh"
export OMPI_MCA_btl=self,tcp

export SINGULARITY_TMPDIR=$TMPDIR/singularity_tmp
export SINGULARITY_CACHEDIR=$TMPDIR/singularity_cache
mkdir -p $SINGULARITY_TMPDIR $SINGULARITY_CACHEDIR

echo "✅ SINGULARITY_TMPDIR = $SINGULARITY_TMPDIR"
echo "✅ SINGULARITY_CACHEDIR = $SINGULARITY_CACHEDIR"

echo "🚀 Running grayscale conversion..."
singularity exec grayscale.sif /opt/app/build/convert_grayscale input output Average || {
    echo "❌ Grayscale conversion failed"
    exit 1
}

echo "🧪 Running grayscale tests..."
singularity exec grayscale.sif /opt/app/build/test_grayscale || {
    echo "❌ Tests failed"
    exit 1
}
