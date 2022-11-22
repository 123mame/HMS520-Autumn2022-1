###
# Code to compute prevalence of type 1 and type 2 diabetes
###
library("data.table")


# input -------------------------------------------------------------------
source("masked/get_draws.R")
age_group_id <- c(1, 2, 3, 4)
location_id <- 102
outdir <- "masked/gbd_2020_test_type2_age_15_plus/"

me_id <- list(
    dm_t1 = 24633,
    dm_t2 = 24634,
    dm_parent = 24632
)

default_get_draws_arguments <- list(
    gbd_id_type = "modelable_entity_id",
    random_epi = "epi",
    measure_id = 5,
    gbd_round_id = 7,
    age_group_id = age_group_id,
    location_id = location_id,
    decomp_step = "iterative"
)

# load data ---------------------------------------------------------------
my_get_draws <- function(...) {
    arguments <- modifyList(default_get_draws_arguments, val = list(...))
    setDT(do.call(get_draws, arguments))
}

draws <- lapply(
    me_id[c("dm_t1", "dm_parent")],
    function(x) my_get_draws(gbd_id = x)
)


# compute dm_t2 -----------------------------------------------------------
# reshape the data table to longer format for dm_t1 and dm_parent
col_names <- names(draws$dm_t1)
col_id <- col_names[endsWith(col_names, "_id")]
col_draw <- col_names[startsWith(col_names, "draw")]

for (name in names(draws)) {
    draws[[name]] <- melt(
        draws[[name]],
        id.vars = col_id,
        measure.vars = col_draw,
        variable.name = "draw_id",
        value.name = "prev_dm"
    )
}

# merge type 1 and type parent together
draws_merged <- merge(
    draws[["dm_t1"]],
    draws[["dm_parent"]],
    by = c(col_id, "draw_id"),
    suffix = c("_t1", "_parent"),
    all = TRUE
)

# rule 1: prev_dm_parent has to be greater than prev_dm_t1
draws_merged[prev_dm_parent < prev_dm_t1, prev_dm_parent := prev_dm_t1]

# rule 2: for age < 15, it can only be type 1 diabetes
age_group_id_under_15 <- c(2, 3)
draws_merged[, prev_dm_t1_ratio := prev_dm_t1 / prev_dm_parent]
draws_merged[age_group_id %in% age_group_id_under_15, prev_dm_t1_ratio := 1]

# compute prev_dm_t1 and prev_dm_t2
draws_merged[, prev_dm_t1 := prev_dm_t1_ratio * prev_dm_parent]
draws_merged[, prev_dm_t2 := (1 - prev_dm_t1_ratio) * prev_dm_parent]

# reshape prev_dm_t2 and save the file
draws_dm_t2 <- dcast(
    draws_merged,
    paste(paste(col_ids, collapse = "+"), "draw_id", sep = "~"),
    value.var = "prev_dm_t2"
)

filepath <- file.path(
    outdir,
    paste0("me_", me_id$dm_t2),
    paste0("5_", location_id, ".csv")
)
fwrite(draws_dm_t2, filepath)
