# linear mixed effects model
library("dplyr")
library("readr")
library("lme4")

source("functions.R")

# load data ---------------------------------------------------------------
df_iris <- read_csv("iris.csv")


# plot data ---------------------------------------------------------------
plot_data(df_iris)


# build model -------------------------------------------------------------
# lmer
mod <- lmer(sepal_width ~ (sepal_length || species), filter(df_iris, test == 0))

coef(mod)
vcov(mod)
summary(mod)

df_iris <- df_iris %>%
    mutate(sepal_width_pred = predict(mod, df_iris))


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

