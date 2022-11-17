# ggplot2
# =======
# install.packages("ggplot2")
library("ggplot2")
library("dplyr")
library("readr")

# we use iris in this practice
df_iris <- iris %>%
    rename_with(~ tolower(gsub(".", "_", .x, fixed = TRUE)))

# data and aesthetic mappings ---------------------------------------------
ggplot(df_iris, aes(x = sepal_length, y = petal_length, color = species)) +
    geom_point()


# geometric objects --------------------------------------------------------
# https://ggplot2.tidyverse.org/reference/
ggplot(df_iris, aes(x = sepal_length, y = petal_length, color = species)) +
    geom_line() +
    geom_point()


# scale: scale_y_log10 ----------------------------------------------------
ggplot(df_iris, aes(x = sepal_length, y = petal_length, color = species)) +
    geom_point() +
    scale_y_log10()


# transformation: coord_trans ---------------------------------------------
ggplot(df_iris, aes(x = sepal_length, y = petal_length, color = species)) +
    geom_point() +
    coord_trans(y = "log10")


# polar coordinate: coord_polar -------------------------------------------
ggplot(df_iris, aes(x = sepal_length, y = petal_length, color = species)) +
    geom_point() +
    coord_polar(theta = "y")


# facet -------------------------------------------------------------------
# facet_wrap, facet_grid
ggplot(df_iris, aes(x = sepal_length, y = petal_length, color = species)) +
    geom_point() +
    facet_wrap(vars(species), nrow = 3)

fig <- ggplot(df_iris, aes(x = sepal_length, y = petal_length, color = species)) +
    geom_point() +
    facet_grid(rows = vars(species), cols = vars(sepal_width))


# save figures: ggsave ----------------------------------------------------
ggsave("graph.png", plot = fig)
