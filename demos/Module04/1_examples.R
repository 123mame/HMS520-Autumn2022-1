# examples
# ========
library("ggplot2")
library("dplyr")

df_iris <- iris %>%
    rename_with(~ tolower(gsub(".", "_", .x, fixed = TRUE))) %>%
    mutate(species = as.character(species))


# scatter plot ------------------------------------------------------------
# useful to see the general trend between dependent and independent variables
# geom_point
ggplot(df_iris) +
    geom_point(aes(x = sepal_length, y = petal_length, color = species))



# box plot ----------------------------------------------------------------
# inspect variable variation across different groups
# geom_boxplot
ggplot(df_iris) +
    geom_boxplot(aes(x = species, y = petal_length, fill = species))


# bar plot ----------------------------------------------------------------
# direct comparison of certain quantity across different groups
# geom_bar, geom_col
ggplot(df_iris) +
    geom_bar(aes(x = species, fill = petal_length))

ggplot(df_iris) +
    geom_col(aes(x = species, y = petal_length))


# line plot ---------------------------------------------------------------
# usual is used for prediction
# geom_line
mod <- lm(petal_width ~ petal_length, df_iris)
print(summary(mod))
df_iris_pred <- df_iris %>%
    mutate(pred_petal_width = predict(mod, df_iris))

ggplot(df_iris_pred) +
    geom_point(aes(x = petal_length, y = petal_width, color = species)) +
    geom_line(aes(x = petal_length, y = pred_petal_width))


# line with uncertainty ---------------------------------------------------
# it is pretty common to plot the CI of the fit
# geom_ribbon
df_temp <- as.data.frame(predict(mod, df_iris, interval = "confidence")) %>%
    rename(
        pred_petal_width = fit,
        pred_petal_width_lower = lwr,
        pred_petal_width_upper = upr
    )
df_iris_pred <- cbind(df_iris, df_temp)

ggplot(df_iris_pred) +
    geom_point(aes(x = petal_length, y = petal_width, color = species)) +
    geom_line(aes(x = petal_length, y = pred_petal_width)) +
    geom_ribbon(aes(x = petal_length,
                    ymin = pred_petal_width_lower,
                    ymax = pred_petal_width_upper), alpha = 0.2)

# -------------------------------------------------------------------------
# ?how can we fit lm for each group

