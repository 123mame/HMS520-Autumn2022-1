# create dataset that will be used in the demo
# ============================================

# set random seed
set.seed(0L)

# create characteristics for the data
keys <- list(
    location_id = 1:5,
    age_group_id = 1:5,
    sex_id = c(0L, 1L)
)

# create cartisian grid using the keys
dat <- do.call(expand.grid, keys)

# simulate population and number of deaths
prob <- 0.1
population <- rpois(nrow(dat), 1000L)
deaths <- rbinom(nrow(dat), population, prob)

# create population and deaths data frame
df_population <- cbind(dat, population)
df_deaths <- cbind(dat, deaths)

# create work hours table
df_hours <- data.frame(
    project = 1:5,
    A = rpois(5, 5),
    B = rpois(5, 5),
    C = rpois(5, 6),
    D = rpois(5, 10)
)
df_pay = data.frame(
    project = 1:5,
    dollar_per_hour = rpois(5, 40)
)

# save the data frames
write.csv(df_population, "population.csv", row.names = FALSE)
write.csv(df_deaths, "deaths.csv", row.names = FALSE)
write.csv(df_hours, "hours.csv", row.names = FALSE)
write.csv(df_pay, "pay.csv", row.names = FALSE)
