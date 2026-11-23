library(tidyverse)  # data wrangling + ggplot
library(haven)      # read SPSS/Stata/SAS files
library(psych)      # descriptives, reliability, factor analysis
library(janitor)    # clean column names
library(survey)

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
    avg_uniqueness = if_else(n_sites_rated > 0,
                                     rowMeans(pick(ends_with("_unique")), na.rm = TRUE),
                                     NA_real_)
  )
### freq
freq <- dat[["F_INTFREQ"]]
dat <- dat |>
  mutate(
    internet_freq = ifelse(freq %in% 1:5, freq, NA)
  )

### identification 0 = republican 1 = dem
identification <- dat[["PARTYSUM_FINAL"]]
dat <- dat |>
  mutate(
    identification = case_when(
      F_PARTYSUM_FINAL == 1 ~ 0,    # Rep/Lean Rep
      F_PARTYSUM_FINAL == 2 ~ 1,    # Dem/Lean Dem
      .default = NA_real_           # 9 (DK/Refused/No lean) and anything else
    )
  )

### descriptives
dat <- dat |>
  mutate(
    age_cat = factor(F_AGECAT,
                     levels = 1:4,
                     labels = c("18-29", "30-49", "50-64", "65plus")),
    
    gender  = factor(F_GENDER,
                     levels = 1:3,
                     labels = c("Man", "Woman", "Other")),
    
    race    = factor(F_RACETHNMOD,
                     levels = 1:5,
                     labels = c("White", "Black", "Asian", "Mixed", "OtherRace")),
    
    educ    = case_when(F_EDUCCAT %in% 1:3 ~ F_EDUCCAT,
                        .default = NA_real_)
  )

saveRDS(dat, "clean_data/atp_w144_clean.rds")        # recommended for your own analysis
write_csv(dat, "clean_data/atp_w144_clean.csv")  

# 
# names(dat) |> str_subset("WEIGHT")   # codebook name is probably WEIGHT_W144
# summary(dat$WEIGHT_W144) 
# 
# w <- dat$WEIGHT_W144[!is.na(dat$avg_perceived_accuracy)]
# sum(w)^2 / sum(w^2) 
# wts <- c("WEIGHT_W144_FB", "WEIGHT_W144_IG", "WEIGHT_W144_XT", "WEIGHT_W144_TT")
# 
# summary(dat[wts])                          # NA counts show who wasn't in each block
# colSums(!is.na(dat[wts]))                  # people with a nonmissing weight per block
# colSums(dat[wts] > 0, na.rm = TRUE)        # people with a positive weight per block
# table(rowSums(!is.na(dat[wts]))) 
# 
# for (s in c("FB", "IG", "XT", "TT")) {
#   cat("\n", s, "\n")
#   print(table(has_weight = !is.na(dat[[paste0("WEIGHT_W144_", s)]]),
#               rated      = dat[[paste0(s, "ACC_W144")]] %in% 1:5))
# }
# 
# models <- list()
# 
# for (s in c("FB", "IG", "XT", "TT")) {
#   d <- dat |>
#     mutate(acc = .data[[paste0(s, "_acc")]],
#            w   = .data[[paste0("WEIGHT_W144_", s)]]) |>
#     filter(!is.na(w))                                   # in the block (weight is defined)
#   
#   des_s <- svydesign(ids = ~1, weights = ~w, data = d)
#   des_s <- subset(des_s, !is.na(acc))                   # then restrict to people with a rating
#   
#   models[[s]] <- svyglm(acc ~ identification + age_cat + gender + educ + race,
#                         design = des_s)
# }
# 
# lapply(models, summary)

