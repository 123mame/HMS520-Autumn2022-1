# dplyr exercise
# ===============
library("dplyr")

df_population <- read.csv("population.csv", stringsAsFactors = FALSE)
df_deaths <- read.csv("deaths.csv", stringsAsFactors = FALSE)

# 1. subset ---------------------------------------------------------------
# subset rows: filter
df_deaths_sub <- filter(df_deaths, location_id == 1)
df_deaths_sub <- filter(df_deaths, deaths > 100)
df_deaths_sub <- filter(df_deaths, location_id == 1, deaths > 100)

# how to filter out all rows with NAs: if_all
df_deaths_sub <- filter(
    df_deaths,
    if_all(.cols = c(location_id, sex_id), .fns = ~ !is.na(.x))
)

# subset cols: select
df_deaths_copy <- df_deaths
df_deaths_copy$random <- "a"
df_deaths_sub <- select(df_deaths, c(location_id, sex_id, deaths))
df_deaths_sub <- select(df_deaths_copy, where(is.numeric))
df_deaths_sub <- select(df_deaths, ends_with("id"))


# 2. modify ---------------------------------------------------------------
# order rows: arrange
df_deaths_mod <- arrange(df_deaths, deaths)
df_deaths_mod <- arrange(df_deaths, desc(deaths))
df_deaths_mod <- arrange(df_deaths, location_id, age_group_id, sex_id)

# order cols: relocate
df_deaths_mod <- relocate(df_deaths, deaths, .before = sex_id)

# rename columns: rename, rename_with
df_deaths_mod <- rename(df_deaths, deaths_ihd = deaths)
df_deaths_mod <- rename_with(df_deaths, tolower)


# 3.  add -----------------------------------------------------------------
# add columns: mutate

# cbind, rbind, bind_rows, bind_cols


# 4.  join ----------------------------------------------------------------

# what if there are columns with the same name: suffix

# what if the number of rows are different: left, right, inner

# what if there are multiple matches

# what if the names you try to match are different in two data frames


# 5.  group ---------------------------------------------------------------


# 6.  pivot ---------------------------------------------------------------
