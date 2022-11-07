# create a name card, with name, phone number and email
john <- list(
    name = "John",
    phone_number = c(2, 0, 6, 1, 2, 3, 1, 2, 3, 4),
    email = "john@gmail.com"
)
typeof(john)

# peek into the list
str(john)

# access element(s) in the named card
john["name"]
john[["name"]]
john$name
john[[1]]

# change john's email to his uw email
john[["email"]] <- "john@uw.edu"

# type of the list
typeof(john)

# remove John's phone number
john$phone_number <- rep(NA, 10)

# convert list into a atomic vector
vec1 <- unlist(john)

# list of lists
lucy <- list(
    name = "Lucy",
    phone_number = rep(0, 10),
    email = "lucy@gmail.com"
)
contacts <- list(
    john = john,
    lucy = lucy
)
str(contacts)
contacts$john <- NULL

# length
length(contacts)
length(lucy)

# lapply
lapply(lucy, length)

# names
names(lucy)

list1 <- list(
    c(1, 2, 3),
    c("a", "b", "c")
)
list1
