# datatable exercise
# ==================
# install.packages("data.table")
library("data.table")
library("tidyr")

df_population <- fread("population.csv")
df_deaths <- fread("deaths.csv")
df_hours <- fread("hours.csv")
df_pay <- fread("pay.csv")

# 1. subset ---------------------------------------------------------------
# subset rows: i expression
df_deaths_sub <- df_deaths[location_id == 1,]
df_deaths_sub <- df_deaths[deaths > 100,]
df_deaths_sub <- df_deaths[(location_id == 1) & (deaths > 100),]

# how to filter out all rows with NAs: complete.cases
df_deaths_sub <- df_deaths[complete.cases(location_id, sex_id),]

df_deaths_sub <- df_deaths[, c("location_id", "sex_id", "deaths")]
df_deaths_sub <- df_deaths[, .(location_id, sex_id, deaths)]
df_deaths_sub <- df_deaths[, list(location_id, sex_id, deaths)]

selected_cols <- c("location_id", "sex_id", "deaths")
df_deaths_sub <- df_deaths[, selected_cols, with = FALSE]
df_deaths_sub <- df_deaths[, ..selected_cols]

# subset cols: j expression, .SD + .SDcols
df_deaths_sub <- df_deaths[, .SD, .SDcols = c("location_id", "sex_id", "deaths")]
df_deaths_sub <- df_deaths[, .SD, .SDcols = selected_cols]


# 2. modify ---------------------------------------------------------------
# order rows: order, i expression
df_deaths_mod <- df_deaths[order(location_id),]
df_deaths_mod <- df_deaths[order(location_id, age_group_id),]
df_deaths_mod <- df_deaths[order(!deaths),]

# rename columns: j expression, setnames
df_deaths_mod <- df_deaths[, list(deaths_ihd = deaths)]
df_deaths_mod <- copy(df_deaths)
setnames(df_deaths_mod, "deaths", "deaths_ihd")
col_names <- names(df_deaths_mod)
setnames(df_deaths_mod, col_names, toupper(col_names))


# 3.  add -----------------------------------------------------------------
# add columns: j expression, :=
df_deaths_add <- copy(df_deaths)
df_deaths_add[, log_deaths := log(deaths)]
df_deaths_add[,
    c("log_deaths", "exp_deaths") := list(log(deaths), exp(deaths))
]
df_deaths_add[
    ,
    `:=`(log_deaths = log(deaths), exp_deaths = exp(deaths))
]

# rbind, cbind
df_deaths_extra = data.table(
    location_id = 6,
    age_group_id = 1:5,
    sex_id = 0,
    deaths = 5
)
df_deaths_add <- rbind(df_deaths, df_deaths_extra)


# 4.  join ----------------------------------------------------------------
df_combined <- merge(
    df_deaths,
    df_population,
    by = c("location_id", "age_group_id", "sex_id"),
    all.x = TRUE
)

# what if there are columns with the same name: suffix
df_deaths_second <- copy(df_deaths)
df_combined <- merge(
    df_deaths,
    df_deaths_second,
    by = c("location_id", "age_group_id", "sex_id"),
    suffix = c("_1st", "_2nd"),
    all.x = TRUE
)

# what if the number of rows are different: left, right, inner
df_deaths_extra = data.table(
    location_id = 6,
    age_group_id = 1:5,
    sex_id = 0,
    deaths = 5
)
df_deaths_add <- rbind(df_deaths, df_deaths_extra)

df_combined <- merge(
    df_deaths,
    df_deaths_add,
    by = c("location_id", "age_group_id", "sex_id"),
    suffix = c("_original", "_add"),
    all.x = TRUE
)

df_combined <- merge(
    df_deaths,
    df_deaths_add,
    by = c("location_id", "age_group_id", "sex_id"),
    suffix = c("_original", "_add"),
    all.y = TRUE
)

df_combined <- merge(
    df_deaths,
    df_deaths_add,
    by = c("location_id", "age_group_id", "sex_id"),
    suffix = c("_original", "_add"),
    all = TRUE
)

# what if there are multiple matches
df1 <- data.table(
    index = c(1, 1, 2, 2),
    value = c(1, 2, 3, 4)
)
df2 <- data.table(
    index = c(1, 1, 2),
    value = c(5, 6, 7)
)
df_combined <- merge(
    df1,
    df2,
    by = "index",
    suffix = c("_1", "_2")
)

# what if the names you try to match are different in two data frames
df1 <- data.table(
    index_x = c(1, 1, 2, 2),
    value = c(1, 2, 3, 4)
)
df2 <- data.table(
    index_y = c(1, 1, 2),
    value = c(5, 6, 7)
)
df_combined <- merge(
    df1,
    df2,
    by.x = "index_x",
    by.y = "index_y",
    suffix = c("_1", "_2")
)


# 5.  group and summarize -------------------------------------------------
df_deaths_group <- df_deaths[, list(deaths = sum(deaths)), by = "location_id"]
df_deaths_group <- df_deaths[, list(deaths = sum(deaths)),
                             by = c("location_id", "age_group_id")]

df_combined <- merge(
    df_deaths,
    df_population,
    by = c("location_id", "age_group_id", "sex_id")
)
df_deaths_group <- df_combined[, lapply(.SD, sum),
                               by = c("location_id", "age_group_id"),
                               .SDcols = c("deaths", "population")]


# 7.  chaining ------------------------------------------------------------
df_deaths_sub <- df_deaths %>%
    filter(location_id == 1) %>%
    mutate(log_deaths = log(deaths))

df_deaths_sub <- df_deaths[location_id == 1,][, log_deaths := log(deaths)]


# compute average death_rate for location 1, 2, 3, 4 and
# rank data frame by desc order of the death_rate

df_combined <- merge(
    df_deaths,
    df_population,
    by = c("location_id", "age_group_id", "sex_id")
)
df_combined <- df_combined[location_id %in% c(1, 2, 3, 4),][, death_rate := deaths / population]
df_combined <- df_combined[, list(mean_death_rate = mean(death_rate)), by = "location_id"]
df_combined <- df_combined[order(-mean_death_rate),]



# 8.  pivot ---------------------------------------------------------------

# pivot long
df_long <- melt(
    df_hours,
    id.vars = "project",
    measure.vars = c("A", "B", "C", "D"),
    variable.name = "employee",
    value.name = "hours"
)

# compute how much do we pay for each employee

# pivot wide

# which religion earn the most?
