"https://github.com/derhuerst/db-rest/blob/master/docs/index.md"

"https://www.ipify.org/"

"https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets.html"

require(httr)
require(magrittr)
GET("https://api.ipify.org/", query = list(format = 'json')) %>% content

GET("https://1.db.transport.rest/stations", query = list(query = 'mannheim')) %>% content

