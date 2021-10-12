sample_data <- function(filename, filepath, prob) {
    con <- file(filepath, "r")
    file <- readLines(con, skipNul = T)
    len <- length(file)
    
    ## use rbinom to return 0 or 1 depending on probability
    ## if 1, keep line, else, throw away
    sub_file <- file[rbinom(n = len, size = 1, prob = prob) == 1]
    close(con)
    
    sample_path <- here("data/sampled")
    if (!dir.exists(sample_path)) {
        dir.create(sample_path)
    }
    
    new_file_path <- paste0(sample_path, "/sub_", filename)
    if (!file.exists(new_file_path)) {
        out <- file(new_file_path, "w")
        writeLines(sub_file, con = out)
        close(out)
    }
}