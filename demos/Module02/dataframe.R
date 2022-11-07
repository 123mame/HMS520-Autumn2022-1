rm(list = ls())
# create a data frame
df <- data.frame(a = 1:3, b = c("a", "b", "c"))

# peek into a dataframe
str(df)

# dimensions, number of rows and number of columns
dim(df)
nrow(df)
ncol(df)

# access column(s) in a data frame
df$a
df[["a"]]
df[c("a", "b")]

# access row(s) in a data frame
df[c(1, 2), ]

# assign values for the data frame
df$a <- 0
df[["a"]] <- 1
df[2, "a"] <- 3

# append a row to a data frame
df_new <- rbind(df, list(a = 4, b = "d"))
df_new[nrow(df_new) + 1, ] <- list(a = 5, b = "e")

# how to remove a column?
df_slim <- df_new["b"]

# how to remove a row?
df_new[, -c(1, 2)]
