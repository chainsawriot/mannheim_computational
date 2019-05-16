require(quanteda)
require(tidyverse)
require(rio)
require(stm)

### Data set
#### https://www.kaggle.com/jrobischon/wikipedia-movie-plots

wiki <- readRDS("./data/wiki_movie_plots.RDS") %>% filter(genre != "unknown" & origin == "American")

### DESC STAT

wiki %>% group_by(genre) %>% summarise(n = n()) %>% arrange(desc(n)) %>% print(n = 30)

wiki_dfm <- dfm(corpus(wiki$plot), remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE, remove = stopwords("english"))

usnames <- readRDS('./data/usnames.RDS')

### Remove common first names

wiki_dfm <- dfm_remove(wiki_dfm, usnames)

### STEMMING

char_wordstem(c("win", "winning", "wins", "won", "winner"))
tokens_wordstem(tokens("Hong wins! He is one of the winners of this challenge."), language = 'en')

char_wordstem(c("gewinnen", "gewonnen", "gewinnst", "gewinnend", "Gewinnerinen"), language = "de")

tokens_wordstem(tokens("Hong hat einen roten Rock getragen!"), language = 'de')
tokens_wordstem(tokens("Hong kann weder Deutsch noch Englisch sprechen. Warum lehrt er hier?"), language = 'de')
tokens_wordstem(tokens("Ich versprech dir nichts und geb dir alles. Ich erwarte nichts und träum von Liebe."), language = 'de')


### LEMMATIZING (TRY YOURSELF)

install.packages('udpipe')
require(udpipe)
udmodel <- udpipe_download_model(language = "german")
udpipe(x = "Hong hat einen roten Rock getragen!", object = udmodel)$lemma
### "Hong"     "haben"    "ein"      "rot"      "Rock"     "getragen" "!"
udpipe(x = "Hong trug einen roten Rock!", object = udmodel)$lemma
### [1] "Hong"   "tragen" "ein"    "rot"    "Rock"   "!" 
udpipe(x = "ist war wäre seien waren bist sein", object = udmodel)$lemma

wiki_dfm_stem <- dfm_wordstem(wiki_dfm)

### remove sparse term

wiki_dfm_processed <- dfm_trim(wiki_dfm_stem, min_docfreq = 50) # 

dfm_tfidf(wiki_dfm_processed) %>% textplot_wordcloud(color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'), n = 100)

dfm_stm <- quanteda::convert(wiki_dfm_processed, to = "stm")
saveRDS(dfm_stm, "./data/movie_dfm_stm.RDS")

### TO CREATE MORE MEMORY: RESTART THE R SESSION

require(quanteda)
require(stm)
require(tidyverse)

dfm_stm <- readRDS("./data/movie_dfm_stm.RDS")

install.packages(c('geometry', 'Rtsne', 'rsvd'))
stm_model <- stm(dfm_stm$documents, dfm_stm$vocab, K = 0, data = dfm_stm$meta, init.type = "Spectral", seed = 46709394)
##saveRDS(stm_model, "./data/stm_mode.RDS")

### TO CREATE MORE MEMORY: RESTART THE R SESSION

require(quanteda)
require(stm)
require(tidyverse)

dfm_stm <- readRDS("./data/movie_dfm_stm.RDS")
stm_model <- readRDS("./data/stm_mode.RDS")
wiki <- readRDS("./data/wiki_movie_plots.RDS") %>% filter(genre != "unknown" & origin == "American") %>% select(title, year, genre)


labelTopics(stm_model)
plot(stm_model, type = "summary")
topicQuality(stm_model, docments = dfm_stm$documents)

##devtools::install_github("cpsievert/LDAvis")
##install.packages('servr')
toLDAvis(stm_model, docs = dfm_stm$documents, reorder.topics = FALSE)


theta <- as.data.frame(stm_model$theta)
colnames(theta) <- paste0("topic", 1:64)

wiki_theta <- bind_cols(wiki, theta)

findTopic(stm_model, c('robot'))

wiki_theta %>% arrange(desc(topic48)) %>% select(title, year, topic48, genre)

findTopic(stm_model, c('indian'))
wiki_theta %>% arrange(desc(topic50)) %>% select(title, year, topic50, genre)

chart_title  <- paste0(labelTopics(stm_model)[[1]][50,], collapse = ", ")

wiki_theta %>% filter(year > 1930) %>% group_by(year) %>% summarise(mean_theta = mean(topic50)) %>% ggplot(aes(y = mean_theta, x = year, group = 1)) +  
  geom_line() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + ggtitle(chart_title)


chart_title  <- paste0(labelTopics(stm_model)[[1]][48,], collapse = ", ")
wiki_theta  %>% filter(year > 1930) %>% group_by(year) %>% summarise(mean_theta = mean(topic48)) %>% ggplot(aes(y = mean_theta, x = year, group = 1)) +  
  geom_line() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + ggtitle(chart_title)

wiki_theta %>% filter(year > 1930) %>% group_by(year) %>% summarise(mean_theta = mean(topic48)) %>% summarise(cor_year = cor(as.numeric(year), mean_theta))

chart_title  <- paste0(labelTopics(stm_model)[[1]][11,], collapse = ", ")
wiki_theta %>% filter(year > 1930) %>% group_by(year) %>% summarise(mean_theta = mean(topic11)) %>% ggplot(aes(y = mean_theta, x = year, group = 1)) +  
  geom_line() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + ggtitle(chart_title)


wiki_theta %>% filter(genre == "film noir") %>% summarise_at(vars(topic1:topic64), mean) %>% t %>% which.max

chart_title  <- paste0(labelTopics(stm_model)[[1]][49,], collapse = ", ")
wiki_theta %>% filter(year > 1930) %>% group_by(year) %>% summarise(mean_theta = mean(topic49)) %>% ggplot(aes(y = mean_theta, x = year, group = 1)) +  
  geom_line() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + ggtitle(chart_title)


wiki_theta %>% filter(str_detect(title, "Moneyball")) %>% select(topic1:topic64) %>% t %>% which.max -> topic_number
paste0(labelTopics(stm_model)[[1]][topic_number,], collapse = ", ")

wiki_theta %>% filter(str_detect(title, "Pulp Fiction")) %>% select(topic1:topic64) %>% t %>% which.max -> topic_number
paste0(labelTopics(stm_model)[[1]][topic_number,], collapse = ", ")

wiki_theta %>% filter(str_detect(title, "V for Vendetta")) %>% select(topic1:topic64) %>% t %>% which.max -> topic_number
paste0(labelTopics(stm_model)[[1]][topic_number,], collapse = ", ")

wiki_theta %>% filter(str_detect(title, "Saving Private Ryan")) %>% select(topic1:topic64) %>% t %>% which.max -> topic_number
paste0(labelTopics(stm_model)[[1]][topic_number,], collapse = ", ")
