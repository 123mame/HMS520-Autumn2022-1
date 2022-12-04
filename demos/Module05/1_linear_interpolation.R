# linear interpolation
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
# approxfun
df_train <- df_iris %>%
    filter(test == 0) %>%
    group_by(sepal_length) %>%
    summarise(sepal_width = mean(sepal_width), species = first(species))

ggplot() +
    geom_point(
        data = df_iris,
        aes(x = sepal_length, y = sepal_width, color = species)
    ) +
    geom_point(
        data = df_train,
        aes(x = sepal_length, y = sepal_width, color = species),
        shape = 14
    )

fun <- with(df_train, approxfun(x = sepal_length, y = sepal_width, rule = 2))

df_iris <- df_iris %>%
    mutate(sepal_width_pred = fun(df_iris$sepal_length))


# plot fit ----------------------------------------------------------------
plot_fit(df_iris)


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
