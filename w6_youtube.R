require(rio)
require(tidyverse)
require(quanteda)


## data source: https://www.kaggle.com/datasnaek/youtube-new/version/114

youtube <- readRDS("./data/de_youtube.RDS")

set.seed(46709394)
label <- sample(c(rep(TRUE, 25000), rep(FALSE, 4628)))
youtube %>% mutate(training = label) -> youtube


youtube_corpus <- corpus(youtube$title)

docvars(youtube_corpus, "high_views") <- youtube$high_views
docvars(youtube_corpus, "training") <- youtube$training

youtube_dfm <- dfm(youtube_corpus, tolower = TRUE)

youtube_training <- dfm_subset(youtube_dfm, docvars(youtube_dfm, "training"))

nb_model <- textmodel_nb(youtube_training, y = docvars(youtube_training, "high_views"))
summary(nb_model)
table(predicted = predict(nb_model), actual = docvars(youtube_training, "high_views"))

youtube_test <- dfm_subset(youtube_dfm, !docvars(youtube_dfm, "training"))
table(predicted = predict(nb_model, youtube_test), actual = docvars(youtube_test, "high_views"))

proposed_title <- "Hong bringt euch bei, wie man quanteda benutzt!"
proposed_title_dfm <- dfm_select(dfm(corpus(proposed_title), tolower = TRUE), pattern = youtube_training)
predict(nb_model, proposed_title_dfm, type = "probability") 

### Propose a better title for me, so that more people will watch my video and learn some quanteda!

