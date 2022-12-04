rm(list = ls())
library("dplyr")
library("readr")
library("ggplot2")

source("functions.R")

# load data ---------------------------------------------------------------
df_iris <- read_csv("iris.csv")

# plot data ---------------------------------------------------------------
plot_data(df_iris)


# build model -------------------------------------------------------------
# lm with group
df_iris_group <- group_split(df_iris, species)
names(df_iris_group) <- sapply(df_iris_group, function(x) x$species[1])

mod <- lapply(
    df_iris_group,
    function(x) lm(sepal_width ~ sepal_length, data = filter(x, test == 0))
)

df_iris_group <- lapply(
    df_iris_group,
    function(x) mutate(x, sepal_width_pred = predict(mod[[x$species[1]]], x))
)

df_iris <- bind_rows(df_iris_group)


# plot fit ----------------------------------------------------------------
plot_fit_group(df_iris)


# summarize fit -----------------------------------------------------------
outsample_rsme <- with(
    filter(df_iris, test == 1),
    get_rsme(sepal_width, sepal_width_pred)
)
insample_rsme <- with(
    filter(df_iris, test == 0),
    get_rsme(sepal_width, sepal_width_pred)
)
print(paste("outsample rsme", outsample_rsme))
print(paste("insample rsme", insample_rsme))
