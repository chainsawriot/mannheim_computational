require(tidyverse)
require(rvest)

mkw_news <- read_html("http://mkw.uni-mannheim.de/meldungsarchiv/index.xml")
mkw_news %>% html_nodes('item') -> mkw_items
mkw_items[[1]] %>% html_node('encoded') %>% html_text

rsf <- read_html('https://rsf.org/en/germany')

rsf %>% html_nodes("h1.desktop-hide") %>% html_text %>% str_trim
rsf %>% html_node('div.white-b__text') %>% html_nodes('p') %>% html_text %>% nth(-2)
rsf %>% html_nodes("p.white-b__ranking-text") %>% nth(4) %>% html_text %>% str_extract('[0-9\\.]+') %>% as.numeric

rsf <- read_html('https://rsf.org/en/united-states')
rsf %>% html_node('div.field_item')

rsf %>% html_nodes('p')


rsf2019 <- read_html("https://rsf.org/en/ranking/2019") %>% html_nodes('li.country_name_item') %>% html_nodes('span.ranking-map__panel-name') %>% html_text %>% tolower %>% str_replace(" of " ," ") %>% str_replace_all("[ /]+", "-")
### côte-d’ivoire

rsf2019[rsf2019 == "côte-d’ivoire"] <- "cote-divoire"


scrape <- function(code) {
  rsf <- read_html(paste0('https://rsf.org/en/', code))
  rsf %>% html_nodes("h1.desktop-hide") %>% html_text %>% str_trim -> country
  print(country)
  rsf %>% html_node('div.white-b__text') %>% html_nodes('p') %>% html_text %>% nth(-2) -> desc
  rsf %>% html_nodes("p.white-b__ranking-text") %>% nth(4) %>% html_text %>% str_extract('[0-9\\.]+') %>% as.numeric -> score
  Sys.sleep(1)
  tibble(country = country, desc = desc, score = score)
}

allres <- map_dfr(rsf2019, scrape)
saveRDS(allres, 'rsf.RDS')

"http://www.songtextemania.com/"

ramm <- read_html('http://www.songtextemania.com/bushido_songtexte.html')

ramm %>% html_nodes('ul.album') %>% html_nodes('li') %>% html_nodes('a') %>% html_attr('href') %>% unique -> urls

url <- urls[7]
scrape <- function(url) {
  lyric_page <- read_html(paste0('http://www.songtextemania.com', url))
  lyric_page %>% html_node('div.lyrics-body') %>% html_text %>% str_replace(fixed('try{_402_Show();}catch(e){}'), "") -> lyrics
  lyric_page %>% html_node('h1') %>% html_text %>% str_replace(" Songtext$", "") -> title
  print(title)
  tibble(url, lyrics, title)
}

rammstein_lyrics <- map_dfr(urls, scrape)

rammstein_lyrics %>% filter(!is.na(lyrics)) %>% pull(lyrics) %>% corpus %>% dfm(remove_punct = TRUE, remove_url = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, remove = c(stopwords('de'), stopwords('en'))) %>%dfm_tfidf %>% textplot_wordcloud(color = c('red', 'pink', 'green', 'purple', 'orange', 'blue'))


require(quanteda)

