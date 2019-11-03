library(tidytext)
library(pdftools)
library(tidyverse)
library(wordcloud)

# Grab PDF

report <- pdf_text("report_smaller.pdf")

#report[1:2]

# Transform vector into a tibble
text_df <- tibble(text = report) %>%
  unnest_tokens(word, text) %>%
  mutate(linenumber = row_number())

# Clean up stop words
data("stop_words")

tidy_df <- text_df %>%
  anti_join(stop_words) %>%
  count(word, sort=TRUE)

# Remove numbers 

tidy_no_numb <- tidy_df %>%
  filter(is.na(as.numeric(word)) )

# Wordcloud
wordcloud(tidy_no_numb$word, tidy_no_numb$n, max.words = 40, ordered.colors = TRUE)

####
# Sentiments

nrc_sentiment <- get_sentiments("nrc")

report_sent <- inner_join(tidy_no_numb, nrc_sentiment, by="word") # join by common words

ggplot(data = report_sent) + geom_bar(x=sentiments, ) 

