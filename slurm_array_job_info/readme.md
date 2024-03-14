This small utility script outputs a tsv resources used by all array jobs managed by slurm.

# To run
`bash path/to/slurm_array_job_info.sh <array_job_id> <job_number>`

Example  
`bash path/to/slurm_array_job_info.sh 23226451 12`
A tsv file titled `slurm_resource_23226451.tsv` will be generated in the current directory.
