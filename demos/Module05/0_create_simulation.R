# create simulation
library("dplyr")
library("readr")


# standarize iris data ----------------------------------------------------
df_iris <- iris %>%
    rename_with(~ tolower(gsub(".", "_", .x, fixed = TRUE)))



# create training and testing split ---------------------------------------
seed <- 123L
set.seed(seed)

n <- nrow(df_iris)
n_test <- as.integer(0.1 * n)

i_test <- sample.int(n, size = n_test)
df_iris$test <- 0
df_iris[i_test, "test"] <- 1

write_csv(df_iris, "iris.csv")
