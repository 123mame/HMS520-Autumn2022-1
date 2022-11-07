# true or false
TRUE
typeof(TRUE)
FALSE
typeof(FALSE)
T
F

# and
TRUE & TRUE
FALSE & TRUE
FALSE & FALSE
NA & FALSE
NA & TRUE

# or
FALSE | TRUE
NA | TRUE

# not
!TRUE
!FALSE

# all
vec <- rep(0, 5)
all(vec == 0)

# any
vec2 <- c(1, 2, 3, NA)
any(is.na(vec2))
