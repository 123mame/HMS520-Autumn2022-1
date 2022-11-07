# dplyr exercise
# ===============
# install.packages("dplyr")
# install.packages("tidyr")
library("dplyr")
library("tidyr")

df_population <- read.csv("population.csv", stringsAsFactors = FALSE)
df_deaths <- read.csv("deaths.csv", stringsAsFactors = FALSE)
df_hours <- read.csv("hours.csv", stringsAsFactors = FALSE)
df_pay <- read.csv("pay.csv", stringsAsFactors = FALSE)

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
df_deaths_add <- mutate(
    df_deaths,
    log_deaths = log(deaths),
    log_deaths_1 = log_deaths + 1,
)

# cbind, rbind, bind_rows, bind_cols
df_deaths_extra = data.frame(
    location_id = 6,
    age_group_id = 1:5,
    sex_id = 0,
    deaths = 5
)
df_deaths_add <- rbind(df_deaths, df_deaths_extra)
df_deaths_add <- bind_rows(df_deaths, df_deaths_extra, .id = "new")
df_deaths_new_col <- data.frame(
    log_deaths = log(df_deaths$deaths)
)
df_deaths_add <- cbind(df_deaths, df_deaths_new_col)

# 4.  join ----------------------------------------------------------------

df_combined <- left_join(
    df_deaths,
    df_population,
    by = c("location_id", "age_group_id", "sex_id")
)

# what if there are columns with the same name: suffix
df_deaths_second <- df_deaths
df_combined <- left_join(
    df_deaths,
    df_deaths_second,
    by = c("location_id", "age_group_id", "sex_id")
)

# what if the number of rows are different: left, right, inner
df_deaths_extra = data.frame(
    location_id = 6,
    age_group_id = 1:5,
    sex_id = 0,
    deaths = 5
)
df_deaths_add <- rbind(df_deaths, df_deaths_extra)
df_combined <- left_join(
    df_deaths_add,
    df_population,
    by = c("location_id", "age_group_id", "sex_id")
)
df_combined <- right_join(
    df_deaths_add,
    df_population,
    by = c("location_id", "age_group_id", "sex_id")
)
df_combined <- inner_join(
    df_deaths_add,
    df_population,
    by = c("location_id", "age_group_id", "sex_id")
)
df_combined <- full_join(
    df_deaths_add,
    df_population,
    by = c("location_id", "age_group_id", "sex_id")
)

# what if there are multiple matches
df1 <- data.frame(
    key = c(1, 1, 2, 2),
    value = c(1, 2, 3, 4)
)
df2 <- data.frame(
    key = c(1, 1, 2),
    value = c(5, 6, 7)
)
df_combined <- left_join(
    df1,
    df2,
    by = "key",
    suffix = c("_1", "_2")
)

# what if the names you try to match are different in two data frames
df1 <- data.frame(
    keyx = c(1, 1, 2, 2),
    value = c(1, 2, 3, 4)
)
df2 <- data.frame(
    keyy = c(1, 1, 2),
    value = c(5, 6, 7)
)
df_combined <- left_join(
    df1,
    df2,
    by = c("keyx" = "keyy"),
    suffix = c("_1", "_2")
)

# 5.  group ---------------------------------------------------------------
df_group <- group_by(
    df_deaths,
    location_id,
    age_group_id
)


# 6.  summarize -----------------------------------------------------------
df_summarize <- summarize(
    df_group,
    mean_deaths = mean(deaths)
)
df_summarize <- summarize(
    df_deaths,
    mean_deaths = mean(deaths)
)


# 7.  pipe operator -------------------------------------------------------
df_deaths_sub <- df_deaths %>%
    filter(location_id == 1) %>%
    mutate(log_deaths = log(deaths))

# compute average death_rate for location 1, 2, 3, 4 and
# rank data frame by desc order of the death_rate

df_final <- df_deaths %>%
    filter(location_id %in% c(1, 2, 3, 4)) %>%
    left_join(df_population,
              by = c("location_id", "age_group_id", "sex_id")) %>%
    mutate(death_rate = round(deaths / population, 2)) %>%
    group_by(location_id) %>%
    summarize(mean_death_rate = mean(death_rate)) %>%
    arrange(desc(mean_death_rate))

View(df_final)

# 8.  pivot ---------------------------------------------------------------

# pivot long
df_long <- pivot_longer(
    df_hours,
    cols = !project,
    names_to = "employee",
    values_to = "hours"
)

# compute how much do we pay for each employee
df_result <- df_long %>%
    left_join(df_pay, by = "project") %>%
    mutate(pay = hours * dollar_per_hour) %>%
    group_by(employee) %>%
    summarize(total = sum(pay))

# pivot wide
df_wide <- pivot_wider(
    df_long,
    id_cols = project,
    names_from = employee,
    values_from = hours
)

df_wide <- pivot_wider(
    df_long,
    id_cols = employee,
    names_from = project,
    values_from = hours
)

# which religion earn the most?
View(relig_income)

df_relig <- relig_income %>%
    pivot_longer(
        cols = !religion,
        names_to = "income",
        values_to = "count"
    ) %>%
    filter(income != "Don't know/refused")

df_total <- df_relig %>%
    group_by(religion) %>%
    summarize(total = sum(count))

df_final <- df_relig %>%
    left_join(df_total, by = "religion") %>%
    mutate(prop = count / total) %>%
    pivot_wider(
        id_cols = religion,
        names_from = income,
        values_from = prop
    ) %>%
    arrange(desc(`>150k`))
