# call a function
a <- "bakka"
substring(a, first = 1, last = 2)
args <- list(
    a,
    first = 1,
    last = 2
)
do.call(substring, args)

# define a function
add_2 <- function(x = 0) {
    x + 2
}
add_2(4)
add_2()

# default values

# return values
add_2 <- function(x) {
    if (x %% 2 == 0) {
        return(x + 3)
    }
    invisible(x + 2)
}
add_2(1)

a <- (b <- 1)

# missing values
add <- function(a = 0, b = 0) {
    if (missing(a) & missing(b)) {
        stop("cannot miss both a and b.")
    }else if (missing(a)) {
        return(b)
    } else if (missing(b)) {
        return(a)
    }
    a + b
}
add(a = 1, b = 1)

# ellipses, ...
to_list <- function(...) {
    list(...)
}

to_list(a = 1, b = 1)

# file_path exercise
# combine all the arguments together
# make sure the path satisfy the standard
file_path <- function(..., fsep = .Platform$file.sep) {
    path <- paste(..., sep = fsep)
    path <- gsub(paste0(fsep, "{2,}"), fsep, path)
    path
}
file_path("folder/", "/file")

# documentation
#' Title
#'
#' @param ... this is the components of the file path
#' @param fsep 
#'
#' @return
#' @export
#'
#' @examples
file_path <- function(...) {
    fsep <-  .Platform$file.sep
    path <- paste(..., sep = fsep)
    path <- gsub(paste0(fsep, "{2,}"), fsep, path)
    path
}

# dependency injection

