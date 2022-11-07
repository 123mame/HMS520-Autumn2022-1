# if, if else, if else if else
vec <- c(1, 2, 3, 4, NA, NA)
if (any(is.na(vec))) {
    print("Something is wrong!")
} else {
    print("Everthing is alright.")
}

a <- -1
sign_a <- 0
if (a < 0) {
    sign_a <- -1
} else if (a > 0) {
    sign_a <- 1
}

abs_a <- if (a < 0) -a else a

# function ifelse
abs_a <- ifelse(a < 0, -a, a)

# switch
