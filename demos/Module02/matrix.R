# create a matrix
vec1 <- 1:6
dim(vec1) <- c(2, 3)

nrow(vec1)
ncol(vec1)
dim(vec1)

mat1 <- matrix(1:6, nrow = 2)

# access elements in a matrix
# access a row
mat1[1, ]

# access first two rows
mat1[c(1, 2), ]

# access a column
mat1[, 1]

# access the 6th elements
mat1[6]

# access entire matrix
mat1[]

# assign values
mat1[] <- 0

# special operations, matrix vector product
vec1 <- 1:3
result <- mat1 %*% vec1
