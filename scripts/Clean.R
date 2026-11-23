library(tidyverse)  # data wrangling + ggplot
library(haven)      # read SPSS/Stata/SAS files
library(psych)      # descriptives, reliability, factor analysis
library(janitor)    # clean column names

dat <- read_csv("data_raw/ATP W144.csv")

glimpse(dat)        # variables, types, first values
summary(dat)        # quick stats and NA counts
head(dat)           # first 6 rows
View(dat)           # spreadsheet-style viewer

sites <- c("FB", "IG", "XT", "TT")
### avg percieved acc
for (s in sites) {
  rating <- dat[[paste0(s, "ACC_W144")]]
  # get all the source cols
  src    <- select(dat, matches(paste0("^", s, "SOURCE_[a-e]_W144")))
  # true/false if each row has atleast 1 source == 1
  gets_news <- rowSums(src == 1, na.rm = TRUE) > 0
  #add the accuracy rating if they get their news
  dat[[paste0(s, "_acc")]] <- ifelse(rating %in% 1:5 & gets_news, rating, NA)
}

#get two final cols to the data, number of sites and avg acc over all the sites
dat <- dat |>
  mutate(
    n_sites_rated          = rowSums(!is.na(pick(ends_with("_acc")))),
    avg_perceived_accuracy = if_else(n_sites_rated > 0,
                                     rowMeans(pick(ends_with("_acc")), na.rm = TRUE),
                                     NA_real_)
  )
### percieved uniqueness
for (s in sites) {
  unique <- dat [[paste0(s, "ELSE_W144")]]
  src    <- select(dat, matches(paste0("^", s, "SOURCE_[a-e]_W144")))
  gets_news <- rowSums(src == 1, na.rm = TRUE) > 0
  dat[[paste0(s, "_unique")]] <- ifelse(unique %in% 1:3 & gets_news, unique, NA)
}

dat <- dat |>
  mutate(
    avg_perceived_accuracy = if_else(n_sites_rated > 0,
                                     rowMeans(pick(ends_with("_unique")), na.rm = TRUE),
                                     NA_real_)
  )

