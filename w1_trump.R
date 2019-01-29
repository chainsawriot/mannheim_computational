require(tidyverse)
require(quanteda)
require(rio)
require(lubridate)

trump_tweets <- import('./data/trump.json') %>% as_tibble

### preprocessing

trump_tweets %>% mutate(is_retweet = is_retweet == "true", created_at = parse_date_time(created_at, orders = '%a %b %d %H:%M:%S %z %Y')) -> trump_tweets

trump_tweets %>% group_by(source) %>% count

trump_tweets %>% filter(str_detect(source, "iPhone|Android")) -> trump_tweets


### quanteda

trump_corpus <- corpus(trump_tweets$text)
docvars(trump_corpus, "source") <- trump_tweets$source
docvars(trump_corpus, "created_at") <- trump_tweets$created_at

## YOUR TURN: add one more docvars - retweet_count

summary(trump_corpus)

## KWIC keyword in context

kwic(trump_corpus, "bush")

kwic(trump_corpus, "cruz")

## YOUR TURN: kwic hillary



## Corpus -> dfm

trump_dfm <- dfm(trump_corpus)

topfeatures(trump_dfm, 100) ## WTF

?dfm
?tokens

trump_dfm <- dfm(trump_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE)
topfeatures(trump_dfm, 100)

stopwords("en")

trump_dfm <- dfm(trump_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = stopwords('en'))

topfeatures(trump_dfm, 100)

textplot_wordcloud(trump_dfm, min_count = 300, random_order = FALSE)

## FYI: explore remove_twitter

## keyness

textstat_keyness(trump_dfm, str_detect(docvars(trump_dfm, "source"), "Android"), sort = TRUE) %>% head(n = 100)

textstat_keyness(trump_dfm, str_detect(docvars(trump_dfm, "source"), "Android"), sort = TRUE) %>% textplot_keyness

## Dictionary-based method: introduction

kwic(trump_corpus, "me")

### because stopwords include pronouns...

trump_dfm2 <- dfm(trump_corpus, remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE)


pronouns <- dictionary(list(
    first_singular = c("i", "me", "my", "mine", "myself"),
    second = c("you", "your", "yours", "yourself", "yourselves"),
    first_plural = c('we', 'us', 'our', 'ours', 'ourselves'),
    third_masculine = c('he', 'him', 'his', 'himself'),
    third_feminine = c('she', 'her', 'hers', 'herself'),
    other = c('it', 'its', 'itself', 'they', 'them', 'their', 'themselves', 'themself')
))

trump_pronouns <- dfm_lookup(trump_dfm2, dictionary = pronouns)

trump_corpus[1]
trump_pronouns[1,]

textstat_keyness(trump_pronouns, str_detect(docvars(trump_dfm, "source"), "Android"), sort = TRUE) %>% textplot_keyness

