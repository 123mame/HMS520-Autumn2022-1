rm(list = ls())
# for loop
# loop over elements
vec <- c("a", "b", "c")
for (x in vec) {
    print(x)
}

# loop over indices
vec <- c("a", "b", "c")
for (i in seq_along(vec)) {
    print(vec[i])
}

# next and break
vec2 <- 1:100
s <- 0
for (i in seq_along(vec2)) {
    if (vec2[i] %% 2 == 1) {
        next
    }
    s <- s + vec2[i]
    if (vec2[i] >= 50) {
        break
    }
}
sum(vec2[(vec2 %% 2 == 0) & (vec2 <= 50)])

x <- 1:100
y <- vector("double", length = length(x))
for (i in seq_along(x)) {
    y[i] <- sin(x[i])
}
y <- sin(x)

# while loop
i <- 0
while (i < 5) {
    print(i)
    i <- i + 1
}

# repeat loop
