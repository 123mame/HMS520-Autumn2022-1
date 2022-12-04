get_rsme <- function(y, y_pred, na_rm = FALSE) {
    sqrt(mean((y - y_pred)^2, na.rm = na_rm))
}

plot_data <- function(df) {
    ggplot() +
        geom_point(
            data = df,
            aes(x = sepal_length, y = sepal_width, color = species)
        )
}

plot_fit <- function(df) {
    ggplot() +
        geom_point(
            data = df,
            aes(x = sepal_length, y = sepal_width, color = species)
        ) +
        geom_point(
            data = filter(df, test == 1),
            aes(x = sepal_length, y = sepal_width),
            shape = 14
        ) +
        geom_line(
            data = df,
            aes(x = sepal_length, y = sepal_width_pred)
        )
}

plot_fit_group <- function(df) {
    ggplot() +
        geom_point(
            data = df,
            aes(x = sepal_length, y = sepal_width, color = species)
        ) +
        geom_point(
            data = filter(df, test == 1),
            aes(x = sepal_length, y = sepal_width),
            shape = 14
        ) +
        geom_line(
            data = df,
            aes(x = sepal_length, y = sepal_width_pred)
        ) +
        facet_wrap(vars(species))
}
