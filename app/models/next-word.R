# load libraries ----------------------------------------
library(dplyr)
library(tibble)
library(feather)
library(multidplyr)
library(parallel)
library(tidytext)

# load data --------------------------------------------

bigrams <- read_feather("data/bigrams.feather")
trigrams <- read_feather("data/trigrams.feather")
quadgrams  <- read_feather("data/quadgram.feather")
bad_words <- read_feather("data/bad_words.feather")

# parallelism ------------------------------------------

cl <- detectCores()
cluster <- new_cluster(cl)
cluster_library(cluster, "dplyr")

# partition data ---------------------------------------

group <- rep(1:cl, length.out = nrow(bigrams))
bigrams <- bind_cols(tibble(group), bigrams)

bigrams <- bigrams %>%
    group_by(group) %>%
    partition(cluster = cluster)



group <- rep(1:cl, length.out = nrow(trigrams))
trigrams <- bind_cols(tibble(group), trigrams)

trigrams <- trigrams %>%
    group_by(group) %>%
    partition(cluster = cluster)
trigrams



group <- rep(1:cl, length.out = nrow(quadgrams))
quadgrams <- bind_cols(tibble(group), quadgrams)

quadgrams <- quadgrams %>%
    group_by(group) %>%
    partition(cluster = cluster)

# match ngrams functions ---------------------------------


matchBigram <- function(input1, n) {
    prediction <- bigrams %>%
        filter(word1 == input1) %>%
        collect() %>%
        mutate(freq = str_count(word2)) %>%
        arrange(desc(freq)) %>%
        pull(word2)
    
    prediction[1:n]
}


matchTrigram <- function(input1, input2, n) {
    # match 1st and 2nd word in trigram, and return third word
    prediction <- trigrams %>%
        filter(word1 == input1, word2 == input2) %>%
        collect() %>%
        mutate(freq = str_count(word3)) %>%
        arrange(desc(freq)) %>%
        pull(word3)
    
    # if no matches, match 1st word in trigram, and return 2nd word
    if (length(prediction) == 0) {
        prediction <- trigrams %>%
            filter(word1 == input2) %>%
            collect() %>%
            mutate(freq = str_count(word2)) %>%
            arrange(desc(freq)) %>%
            pull(word2)
        
        # if no matches, match 2nd word in trigram, and return 3rd word
        if (length(prediction) == 0) {
            prediction <- trigrams %>%
                filter(word2 == input2) %>%
                collect() %>%
                mutate(freq = str_count(word3)) %>%
                arrange(desc(freq)) %>%
                pull(word3)
            
            # all else fails, find match in bigram
            if (length(prediction) == 0) {
                prediction <- matchBigram(input2, n)
            }
        }
    }
    prediction[1:n]
}



matchQuadgram <- function(input1, input2, input3, n) {
    
    # match 1st, 2nd, 3rd word in quadgram, and return 4th word
    prediction <- quadgrams %>%
        filter(word1 == input1, word2 == input2, word3 == input3) %>%
        collect() %>%
        mutate(freq = str_count(word4)) %>%
        arrange(desc(freq)) %>%
        pull(word4)
    
    # match 1st and 2nd, return 3rd word
    if (length(prediction) == 0) {
        prediction <- quadgrams %>%
            filter(word1 == input2, word2 == input3) %>%
            collect() %>%
            mutate(freq = str_count(word3)) %>%
            arrange(desc(freq)) %>%
            pull(word3)
        
        # match 2nd and 3rd, return 4th
        if (length(prediction) == 0) {
            prediction <- quadgrams %>%
                filter(word2 == input2, word3 == input3) %>%
                collect() %>%
                mutate(freq = str_count(word4)) %>%
                arrange(desc(freq)) %>%
                pull(word4)
            
            # if no matches, find match in trigrams
            if (length(prediction) == 0) {
                prediction <- matchTrigram(input2, input3, n)
            }
        }
    }
    
    prediction[1:n]
}


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

# final next-word function ----------------------------------------

next_word <- function(input, n = 5) {
    input <- clean_input(input)
    wordCount <- length(input)
    
    if (wordCount == 0){
        return("please enter a word")
    }
    
    if (wordCount == 1) {
        pred <- matchBigram(input[1], n)
    }
    
    if (wordCount == 2) {
        pred <- matchTrigram(input[1], input[2], n)
    }
    
    if (wordCount == 3) {
        pred <- matchQuadgram(input[1], input[2], input[3], n)
    }
    
    if (wordCount > 3) {
        # match with last three words in input
        input <- input[wordCount - 2:wordCount]
        pred <- matchQuadgram(input[1], input[2], input[3], n)
    }
    
    if(NA %in% pred) {
        return("No predictions available :(")
    }
    else {
        return(pred)
    }
}

