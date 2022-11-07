# please provide three ways to create vector contains 1, 2, ..., 10
vec1 <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
vec1 <- 1:10
vec1 <- seq(1, 10)

# please excess the first and third element
vec1[c(1, 3)]

# please excess the values that is greater than 5
vec1[vec1 > 5]

# please assign all even number to 0
vec1[vec1 %% 2 == 0] <- 0

# remove 2nd to 5th elements
vec1[-(2:5)]
vec1[-1]

# how to combine two vectors
vec2 <- 2:5
c(vec1, vec2)

# create named atomic vectors
vec3 <- c(x = 1, y = 2, z = 3)
names(vec3)
vec3["x"]
names(vec3) <- c("a", "b", "c")

vec4 <- 1:6
names(vec4) <- c("x", "y", "z")

# how to get number of characters of a string
vec5 <- c("a", "b", "c")
length(vec5)
nchar(vec5)

# type coercion
vec6 <- c(TRUE, 0)
