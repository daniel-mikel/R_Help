
# this is a tutorial from datacamp
	# https://campus.datacamp.com/courses/sentiment-analysis-in-r-the-tidy-way/tweets-across-the-united-states?ex=2

# Sentiment Lexicons

# there are several different sentiment lexicons
	# we'll explore three
		# afinn
		# bing
		#nrc
	# the decision on which lexicon to use depends on which question you are trying to answer 

# Load dplyr and tidytext
library("dplyr")
library("tidytext")

# Choose the bing lexicon
get_sentiments("bing")

# Choose the nrc lexicon
  # count() will count the number of rows that share each distinct value of that variable
get_sentiments("nrc") %>%
  count(sentiment) # Count words by sentiment

# geocoded_tweets has been pre-defined
geocoded_tweets

# Access bing lexicon: bing
bing <- get_sentiments("bing")

# Use data frame with text data
geocoded_tweets %>%
  # With inner join, implement sentiment analysis using `bing`
  inner_join(bing)

# getting to know dplyr verbs

# filter() will subset your data based on a true value 
tweets_nrc %>% 
	filter(sentiment == "positive")

# group by will allow R to calculate values for each grou
tweets_nrc %>%
	filter(sentiment == "positive") %>%
	group_by(word)

# summarize calculates a value for each group that passes through it
	# will calculate one value for each group
tweets_nrc %>%
	filter(sentiment == "positive") %>%
	group_by(word) %>%
	summarize(freq = mean(freq))

# arrange will take your results and order them by a variable
tweets_nrc %>%
	filter(sentiment == "positive") %>%
	group_by(word) %>%
	summarize(freq = mean(freq)) %>%
	arrange(desc(freq))

# ungroup will undo a grouping in a dataframe
tweets_nrc %>%
	filter(sentiment == "positive") %>%
	group_by(word) %>%
	summarize(freq = mean(freq)) %>%
	arrange(desc(freq)) %>%
	ungroup


# tweets_nrc has been pre-defined
tweets_nrc

tweets_nrc %>%
  # Filter to only choose the words associated with sadness
  filter(sentiment == "sadness") %>%
  # Group by word
  group_by(word) %>%
  # Use the summarize verb to find the mean frequency
  summarize(freq = mean(freq)) %>%
  # Arrange to sort in order of descending frequency
  arrange(desc(freq))


  # tweets_nrc has been pre-defined
tweets_nrc

joy_words <- tweets_nrc %>%
  # Filter to choose only words associated with joy
  filter(sentiment == "joy")%>%
  # Group by each word
  group_by(word)%>%
  # Use the summarize verb to find the mean frequency
  summarize(freq = mean(freq)) %>%
  # Arrange to sort in order of descending frequency
  arrange(desc(freq))

# Load ggplot2
library("ggplot2")

joy_words %>%
  top_n(20) %>%
  mutate(word = reorder(word, freq)) %>%
  # Use aes() to put words on the x-axis and frequency on the y-axis
  ggplot(aes(x = word, y = freq)) + 
  geom_col() +
  # Make a bar chart with geom_col()
  coord_flip() 