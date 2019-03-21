require(tidyverse)
require(rio)
require(stringr)

### data from https://www.kaggle.com/manjeetsingh/analysis-of-fifa-2018-players-dataset/data
fifa <- import('./data/fifa2018.csv') %>% as_tibble
fifa

### EASY DATA MANIPULATION

glimpse(fifa)

### The concept of pipe

x <- c(10, 20, 30, 50)

mean(x)

### can also be written as

x %>% mean()

### Composition
sqrt(mean(x))

x %>% mean %>% sqrt

### You only need to know six verbs: select, arrange, filter, mutate, summarise, group_by
### Combining these verbs, you can do almost everything.

## verb #1: select: select the variables (columns) from a data frame

select(fifa, Name)
select(fifa, Name, Nationality, Club)

### OR BETTER YET

fifa %>% select(Name, Nationality, Club)

### verb #2: arrange: reorder the data frame according to variable(s).

fifa %>% arrange(Overall)
fifa %>% arrange(desc(Overall))

### Who is that Cris...

fifa %>% arrange(desc(Overall)) %>% select(Name, Overall)

### YOUR TURN: Who are the oldest players?

### One more thing: you can arrange with multiple variables

fifa %>% arrange(Age, desc(Overall)) %>% select(Name, Age, Overall)

### verb #3: filter: select rows satisfying your query.

fifa %>% select(Name, Nationality)
fifa %>% select(Name, Nationality) %>% filter(Nationality == "Germany")
fifa %>% filter(Nationality == "Germany")

fifa %>% filter(Overall < 50)

### YOUR TURN: Who are the german players with the highest Overall score?

### verb #4: mutate: modify the variables (columns)

fifa %>% select(Name, Overall, Potential)
fifa %>% select(Name, Overall, Potential) %>% mutate(Score = Overall + Potential)

## Case study: Value

fifa %>% select(Name, Value) %>% View

fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"))
fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"),
                                        value_number = str_extract(Value, "[0-9\\.]+"))

fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"),
                                        value_number = str_extract(Value, "[0-9\\.]+")) %>%
  mutate(value_ending_meaning = ifelse(value_ending == "M", 1000000, 0))

fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"),
                                        value_number = str_extract(Value, "[0-9\\.]+")) %>%
  mutate(value_ending_meaning = ifelse(value_ending == "M", 1000000, 1000)) %>% View

fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"),
                                        value_number = str_extract(Value, "[0-9\\.]+")) %>%
  mutate(value_ending_meaning = ifelse(value_ending == "M", 1000000, 1000)) %>% 
  mutate(value_ending_meaning = replace_na(value_ending_meaning, 0)) %>% View

## H/A: ?recode, ?replace_na

fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"),
                                        value_number = str_extract(Value, "[0-9\\.]+")) %>%
  mutate(value_ending_meaning = ifelse(value_ending == "M", 1000000, 1000)) %>% 
  mutate(value_ending_meaning = replace_na(value_ending_meaning, 0)) %>%
  mutate(actual_value = as.numeric(value_number) * value_ending_meaning)

## You can select only the thing you need

fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"),
                                        value_number = str_extract(Value, "[0-9\\.]+")) %>%
  mutate(value_ending_meaning = ifelse(value_ending == "M", 1000000, 1000)) %>% 
  mutate(value_ending_meaning = replace_na(value_ending_meaning, 0)) %>%
  mutate(actual_value = as.numeric(value_number) * value_ending_meaning) %>%
  select(Name, Value, actual_value)

### OUR TURN: Who are the player with the higest actual value

fifa %>% select(Name, Value) %>% mutate(value_ending = str_extract(Value, "M|K"),
                                        value_number = str_extract(Value, "[0-9\\.]+")) %>%
  mutate(value_ending_meaning = ifelse(value_ending == "M", 1000000, 1000)) %>% 
  mutate(value_ending_meaning = replace_na(value_ending_meaning, 0)) %>%
  mutate(actual_value = as.numeric(value_number) * value_ending_meaning)

### YOUR TURN: Money ball - select the player with the actual_value less than 1000000,
### with the highest Overall score.


