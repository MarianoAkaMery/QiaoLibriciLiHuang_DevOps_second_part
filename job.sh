#!/bin/bash
#SBATCH --job-name=grayscale_convert
#SBATCH --output=output.log
#SBATCH --error=error.log
#SBATCH --time=00:10:00
#SBATCH --partition=cpu
#SBATCH --ntasks=1

module load singularity

# Make sure output dir exists
mkdir -p /opt/app/output

# Run the grayscale converter
singularity exec grayscale.sif \
  /opt/app/build/convert_grayscale \
  /opt/app/input/symmetric_1.ppm \
  /opt/app/output/result_1.pgm
