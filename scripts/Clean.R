library(tidyverse)  # data wrangling + ggplot
library(haven)      # read SPSS/Stata/SAS files
library(psych)      # descriptives, reliability, factor analysis
library(janitor)    # clean column names

dat <- read_csv("data_raw/ATP W144.csv")

glimpse(dat)        # variables, types, first values
summary(dat)        # quick stats and NA counts
head(dat)           # first 6 rows
View(dat)           # spreadsheet-style viewer

table(dat$gender, useNA = "ifany")  # frequencies, including missing
