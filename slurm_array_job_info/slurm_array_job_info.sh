#!/bin/bash

module load R/4.3.1-fasrc01
module load cmake/3.27.5-fasrc01
module load gcc/13.2.0-fasrc01
export R_LIBS_USER=$HOME/apps/R_4.3.1:$R_LIBS_USER  # attach custom library path

# Input text
job_id=$1
job_no=$2

# Specify the output file path
output_file="slurm_resource_${1}.tsv"

touch temp.txt

for ii in $(seq 1 $job_no)
do
  seff ${job_id}_${ii} >> temp.txt
done

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
Rscript --vanilla ${SCRIPT_DIR}/slurm_array_job_info.R \
  --wd "${PWD}" \
  --input "temp.txt"\
  --output "${output_file}"

rm temp.txt


if [ -f ${output_file} ]; then
	echo "Output slurm resources for array jobs to a TSV - Successful!"
else
	echo "ERROR"
fi

