#!/bin/bash
#SBATCH --array=0-23
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:60:00
#SBATCH --mem=1GB
#SBATCH --job-name=fastqc
#SBATCH --mail-type=END
#SBATCH --mail-user=kra277@nyu.edu
#SBATCH --output=log/01_qc_reports/%A_%a.txt

# Module purge and load
module purge
module load fastqc/0.11.9

# Directory variables
datadir=$SCRATCH/aouizerat_lab/ctv_bismark/raw_fastq
quality_reports=$SCRATCH/aouizerat_lab/ctv_bismark/quality_reports
fastqc_reports=$quality_reports/fastqc

# If directory does not exist create a new directory
if [ ! -d "$quality_reports" ]
then
    mkdir $quality_reports
fi

if [ ! -d "$fastqc_reports" ]
then
    mkdir $fastqc_reports
fi

# open the fastq file directory
cd $datadir

# save the file name in a variable
FILES=($(ls * .fastq.gz))

# Call fastqc command on the file
fastqc -t 4 ${FILES[$SLURM_ARRAY_TASK_ID]} -o $fastqc_reports