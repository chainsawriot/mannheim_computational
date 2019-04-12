require(stringr)

scrabble <- readLines('./data/words.txt')
View(scrabble)

str_subset(scrabble, "Q") ## Anyword with Q
str_subset(scrabble, "^Q") ## Start with Q
str_subset(scrabble, "^QU") ## Start with QU

str_subset(scrabble, "A")
str_subset(scrabble, "A{2}") ## Two A

str_subset(scrabble, "X|Y") ## X or Y
str_subset(scrabble, "^[X-Z]") ## X to Z in the beginning

str_detect(scrabble, "Q")
scrabble[820]

str_extract(scrabble, "QA")

movies <- c('1999', '2001 space odyssey', '24g')

## how to extract all years (19xx and 20xx)? i.e. only 1984 and 2001


