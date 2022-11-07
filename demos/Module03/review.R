
"a"
"abc"
c("a", "b")

# argument name vs variable -----------------------------------------------

a <- 1

test_1 <- function(a) {
    print(a)
    a <- 2
    print(a)
}
test_1(a)
print(a)


# default argument --------------------------------------------------------

test_2 <- function(a, b = 1) {
    print(paste("a", a, sep = " = "))
    print(paste("b", b, sep = " = "))
}
test_2(2)
test_2(2, 2)


# loop over indices vs loop over values -----------------------------------

vec <- c("a", "b", "c")

for (i in seq_along(vec)) {
    print(paste(i, vec[i], sep = ", "))
}

for (x in vec) {
    print(x)
}


# DO NOT change length of an atomic vector in loop ------------------------

vec <- vector(mode = "double", length = 10L)
vec2 <- as.vector(vec)
for (i in 1:10) {
    vec[i] <- i^2
}
