# get bad words from github repository
get_bad_words <- function() {
    url <-
        "https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt"
    bad_words <- read.delim2(
        file = url,
        header = F,
        sep = "\t",
        col.names = "text"
    )
    return(bad_words)
}