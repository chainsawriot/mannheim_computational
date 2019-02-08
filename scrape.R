require(rvest)

mov <- read_html('https://www.metacritic.com/movie/crash/critic-reviews')

mov %>% html_nodes('div.summary') %>% html_text
