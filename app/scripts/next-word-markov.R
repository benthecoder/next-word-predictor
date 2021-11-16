# libraries --------------------------------------------
library(tidyverse)
library(tidytext)
library(markovchain)

# load data --------------------------------------------
markov_uni <- read_rds("models/markov_uni_small.rds")
bad_words <- read_rds("data/bad_words.rds")

# clean input data function ----------------------------------------

clean_input <- function(input) {
    input <- tibble(line = 1:(length(input)), text = input) %>%
        unnest_tokens(word, text) %>%
        filter(!str_detect(word, "\\d+")) %>%
        mutate_at("word", str_replace, "[[:punct:]]", "") %>% # remove punctuation
        anti_join(bad_words, by = "word") %>% # remove profane words
        pull(word)
    input
}

# markov function  ---------------------------------

next_word <- function(word, num = 5) {
    word <- clean_input(word)
    length <- length(word)
    
    if (length == 0){
        return("please enter a word")
    }
    
    if (length > 1) {
        word <- word[length]
    }
    
    # checking for word in markov chain
    pred <- try(markovchainSequence(
        n = 1,
        markovchain = markov_uni$estimate,
        t0 = word,
        include.t0 = F
    ), silent=T)
    
    if (nchar(pred[1]) > 100) {
        return("no predictions available :(")
    }
    
    sents <- c()
    for (i in 1:num) {
        set.seed(i) # randomize generation
        {
            sent <- markovchainSequence(
                n = 1,
                markovchain = markov_uni$estimate,
                t0 = word,
                include.t0 = F
            ) %>%  # set the first word
                paste(collapse = " ")
            sents <- c(sents, sent)
        }
    }
    unique(sents)
}

next_word('hi')