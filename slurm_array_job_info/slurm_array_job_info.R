#!/usr/bin/env Rscript
library(optparse)

option_list = list(
  make_option(c("--input"), type="character", default=NULL, 
              help="Path to input file.", metavar="character"),
  make_option(c("--wd"), type="character", default=NULL, 
              help="Working directory.", metavar="character"),
  make_option(c("--output"), type="character", default=NULL, 
              help="Output file.", metavar="character")
  
); 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

setwd(opt$wd)

library(stringr)
library(readr)

text <- read_file(opt$input)
# Split the text into individual job records
# Assuming "---" does not appear in the text, it can be used as a temporary separator for jobs
text_v <- str_split(text, "\n", simplify = FALSE)[[1]]

jobs <- str_split(text_v, ":", n = 2, simplify = TRUE)
jobs <- as.data.frame(jobs)
jobs <- jobs[-nrow(jobs), ]


jobs_split <- split(jobs,rep(1:(nrow(jobs)/12),each=12))

header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df <- df[-1,]
  return(df)
}

for (ii in 1:length(jobs_split)){
  jobs_split[[ii]] <- as.data.frame(t(jobs_split[[ii]]))
  jobs_split[[ii]] <- header.true(jobs_split[[ii]])
}

jobs_table <- do.call("rbind", jobs_split)

write_tsv(jobs_table, file = opt$output)