library(Hmisc)
library(mc2d)
library(tidyverse)
library(skimr)

rm(list=ls())
# The script is to be saved in the src directory
# The project directory is one  level above the src directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
setwd('..')
set.seed(42)

estimates <- read_csv('data/time_estimates.csv')
