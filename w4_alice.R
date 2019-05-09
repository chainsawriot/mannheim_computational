require(rtweet)
require(quanteda)
require(tidyverse)

aw <- search_tweets("@alice_weidel")

aw_timeline <- get_timeline("@alice_weidel", n = 1000)
aw_corpus <- corpus(aw_timeline$text)

aw_dfm <- dfm(aw_corpus, remove = stopwords('de'),
              remove_numbers = TRUE, 
              remove_punct = TRUE,
              remove_symbols = TRUE, 
              remove_separators = TRUE,
              remove_twitter = FALSE, 
              remove_hyphens = TRUE, 
              remove_url = TRUE)

aw_dfm %>% dfm_tfidf %>% textplot_wordcloud(max_words = 150, 
                   color = c('blue', 'red'))

get_timeline("@alice_weidel", n = 1000) %>% pull('text') %>% corpus %>% 
    dfm(remove = stopwords('de'),
        remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE, remove_separators = TRUE,
        remove_twitter = FALSE, remove_hyphens = TRUE, remove_url = TRUE) %>%
    dfm_tfidf %>% textplot_wordcloud(max_words = 150, 
                                     color = c('blue', 'red'))