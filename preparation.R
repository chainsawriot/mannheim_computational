require(tidytext)
require(tidyverse)
require(quanteda)

get_sentiments('afinn') -> afinn_raw

afinn_raw %>% split(afinn_raw$score) %>% map(function(x) x$word) -> afinn_list

names(afinn_list) <- c(paste0("neg", 5:1), "zero", paste0("pos", 1:5))
saveRDS(dictionary(afinn_list), "./data/afinn.RDS")

get_sentiments('nrc') %>% filter(sentiment == 'negative') %>% pull(word) %>% str_replace('ing$', 'in*') %>% saveRDS('./data/nrc_neg.RDS')

devtools::install_github("mkearney/rtweet")
install.packages('httpuv')
require(rtweet)

## Trigger the authentication
cnn_fds <- get_friends("cnn")

tmls <- get_timelines(c("CDU", "CSU", "SPDDE", "Die_Gruenen", "FDP", "dieLinke", "AfD"), n = 3200)

tmls %>% filter(screen_name == 'AfD')

saveRDS(tmls, "./data/german_party_tweets.RDS")
