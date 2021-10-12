# Creates a table given the text files
data_info <- function(names) {
    # file size
    size <- file.info(here(data_path, names))$size / (2 ** 20)
    
    # word count
    (total_words_bash <-
            system("wc -w ../data/original/*.txt", intern = TRUE))
    regexp <- "[[:digit:]]+"
    
    word_count <-
        unlist(str_split(str_extract(total_words_bash, regexp), " ")[1:3])
    
    line_count <- c()
    max_line <- c()
    
    for (name in names) {
        file <- readTxtFile(here(data_path, name))
        num_lines <- length(file)
        
        longest_line <- as.numeric(summary(nchar(file))["Max."])
        
        line_count <- c(line_count, num_lines)
        max_line <- c(longest_line, max_line)
    }
    
    tb <- tibble(
        "file_name" = names,
        "size" = paste(round(size, 1), "MB"),
        "line_count" = line_count,
        "word_count" = as.integer(word_count),
        "max_line" = as.integer(max_line)
    ) %>%
        mutate_if(is.numeric, list(~ prettyNum(., big.mark = ",")))
    
    return(tb)
}