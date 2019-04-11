require(stringr)

scrabble <- readLines('./data/words.txt')
View(scrabble)

str_subset(scrabble, "Q") ## Anyword with Q
str_subset(scrabble, "^Q") ## Start with Q
str_subset(scrabble, "^QU") ## Start with QU

str_subset(scrabble, "A")
str_subset(scrabble, "A{2}") ## Two A

str_subset(scrabble, "X|Y") ## X or Y

str_detect(scrabble, "Q")
scrabble[820]

str_extract(scrabble, "QA")
