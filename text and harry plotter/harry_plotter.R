# tutorial from 
	# https://paulvanderlaken.com/2017/08/03/harry-plotter-celebrating-the-20-year-anniversary-with-tidytext-the-tidyverse-and-r/

# download library("harrypotter")
if (packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
devtools::install_github("bradleyboehmke/harrypotter")

library("plyr")
library("harrypotter")
library("tidytext")
library("tidyverse")
library("wordcloud")

setwd("/home/dan/R/R_Help/text and harry plotter/wd")
options(stringsAsFactors = F, # do not convert upon loading
        scipen = 999, # do not convert numbers to e-values
        max.print = 200) # stop printing after 200 values

theme_set(theme_light()) # set default ggplot theme to light
fs = 12 # default plot font size

# load book chapters

hp_words <- list(
 philosophers_stone = philosophers_stone,
 chamber_of_secrets = chamber_of_secrets,
 prisoner_of_azkaban = prisoner_of_azkaban,
 goblet_of_fire = goblet_of_fire,
 order_of_the_phoenix = order_of_the_phoenix,
 half_blood_prince = half_blood_prince,
 deathly_hallows = deathly_hallows
) %>%
 ldply(rbind) %>% # bind all chapter text to dataframe columns
 mutate(book = factor(seq_along(.id), labels = .id)) %>% # identify associated book
 select(-.id) %>% # remove ID column
 gather(key = 'chapter', value = 'text', -book) %>% # gather chapter columns to rows
 filter(!is.na(text)) %>% # delete the rows/chapters without text
 mutate(chapter = as.integer(chapter)) %>% # chapter id to numeric
 unnest_tokens(word, text, token = 'words') # tokenize data frame


# plot word frequency by book
hp_words %>% 
	group_by(book, word) %>%
 	anti_join(stop_words, by = "word") %>% 
	count() %>% 
	arrange(desc(n)) %>% 
	group_by(book) %>% 
	mutate(top = seq_along(word)) %>%
	filter(top <= 15) %>%
	ggplot(aes(x = -top, 
		fill = book)) + 
	geom_bar(aes(y = n), 
		stat = 'identity', 
		col = 'black') +
	geom_text(aes(y = ifelse(n > max(n) / 2, 
		max(n) / 50, 
		n + max(n) / 50),
		label = word), 
		size = fs/3, 
		hjust = "left") +
	theme(legend.position = 'none', 
        text = element_text(size = fs), 
        axis.text.x = element_text(angle = 45, hjust = 1, 
        	size = fs/1.5), 
        axis.ticks.y = element_blank(), 
        axis.text.y = element_blank()) + 
	labs(y = "Word count", x = "", 
       title = "Harry Plotter: Most Frequent Words") +
	facet_grid(. ~ book) + 
	coord_flip()


# tidytext includes three sentiment dictionaries
	# AFFIN: including bipolar sentiment scores ranging from -5 to 5
	# bing: including bipolar sentiment scores
	# nrc: including sentiment scores for many different emotions (e.g., anger, joy, and surprise)

# extract sentiment with three dictionaries
hp_senti <- bind_rows(
  hp_words %>% 
    # delete neutral words
    inner_join(get_sentiments("afinn"), 
    	by = "word") %>%
    # identify sentiment
    filter(score != 0) %>% 
    # all scores to positive
    mutate(sentiment = ifelse(score < 0, 
    	'negative', 'positive')) %>% 
    mutate(score = sqrt(score ^ 2)) %>% 
    # create dictionary identifier
    group_by(book, 
    	chapter, 
    	sentiment) %>% 
    mutate(dictionary = 'afinn'), 
  # 2 BING 
  hp_words %>% 
    inner_join(get_sentiments("bing"), 
    	by = "word") %>%
    group_by(book, 
    	chapter, 
    	sentiment) %>%
    # create dictionary identifier
    mutate(dictionary = 'bing'), 
  # 3 NRC 
  hp_words %>% 
    inner_join(get_sentiments("nrc"), 
    	by = "word") %>%
    group_by(book, 
    	chapter, 
    	sentiment) %>%
    # create dictionary identifier
    mutate(dictionary = 'nrc') 
)

# wordcloud
hp_senti %>%
  group_by(word) %>%
  # summarize count per word
  count() %>% 
  # take root to decrease outlier impact
  mutate(log_n = sqrt(n)) %>% 
  with(wordcloud(word, log_n, max.words = 100))


  # It appears we need to correct for some words that occur in the sentiment dictionaries but have a different meaning in J.K. Rowling’s books. Most importantly, we need to filter two character names.
hp_senti_sel <- hp_senti %>% 
	filter(!word %in% c("harry","moody"))

# VIZUALIZE MOST FREQUENT WORDS PER SENTIMENT
hp_senti_sel %>% 
  group_by(word, sentiment) %>%
  # summarize count per word per sentiment
  count() %>% 
  group_by(sentiment) %>%
  # most frequent on top
  arrange(sentiment, desc(n)) %>% 
  # identify rank within group
  mutate(top = seq_along(word)) %>% 
  # keep top 15 frequent words
  filter(top <= 15) %>% 
  # create barplot
  ggplot(aes(x = -top, 
  	fill = factor(sentiment))) + 
  # make sure words are printed either in or next to bar
  geom_bar(aes(y = n), 
  	stat = 'identity', 
  	col = 'black') +
  geom_text(aes(y = ifelse(n > max(n) / 2, 
  		max(n) / 50, 
  		n + max(n) / 50), 
  	label = word), 
  	size = fs/3, 
  	hjust = "left") +
  # remove legend
  theme(legend.position = 'none', 
        # determine fontsize
        text = element_text(size = fs), 
        # rotate x text
        axis.text.x = element_text(angle = 45, 
        	hjust = 1), 
        # remove y ticks
        axis.ticks.y = element_blank(), 
        # remove y text
        axis.text.y = element_blank()) + 
  # add manual labels
  labs(y = "Word count", 
  	x = "", 
    title = "Harry Plotter: Words carrying sentiment as counted throughout the saga",
    subtitle = "Using tidytext and the AFINN, bing, and nrc sentiment dictionaries") +
  # separate plot for each sentiment
  facet_grid(. ~ sentiment) + 
  # flip axes
  coord_flip() 


# As positive and negative sentiment is included in each of the three dictionaries we can to compare and contrast scores.
plot_sentiment <- hp_senti_sel %>% 
  group_by(dictionary, sentiment, book, chapter) %>%
  # summarize AFINN scores
  summarize(score = sum(score), 
            # summarize bing and nrc counts
            count = n(), 
            # move bing and nrc counts to score 
            score = ifelse(is.na(score), count, score))  %>%
  # only retain bipolar sentiment
  mutate(score = ifelse(sentiment == 'negative', -score, score)) %>% # reverse negative values
  filter(sentiment %in% c('positive','negative')) %>%   
  # create area plot
  ggplot(aes(x = chapter, y = score)) +    
  geom_area(aes(fill = score > 0),stat = 'identity') +
  # change colors
  scale_fill_manual(values = c('red','green')) + 
  # add black smoothed line without standard error
  geom_smooth(method = "loess", se = F, col = "black") + 
  # remove legend
  theme(legend.position = 'none', 
  		# change font size
        text = element_text(size = fs)) + 
  # add labels
  labs(x = "Chapter", y = "Sentiment score", 
       title = "Harry Plotter: Sentiment",
       subtitle = "Using tidytext and the AFINN, bing, and nrc sentiment dictionaries") +
  # separate plot per book and dictionary and free up x-axes
  facet_grid(dictionary ~ book, scale = "free_x")

plot_sentiment


# Finally, let’s look at the other emotions that are included in the nrc dictionary.
hp_senti_sel %>% 
  # only retain other sentiments (nrc)
  filter(!sentiment %in% c('negative','positive')) %>% 
  group_by(sentiment, book, chapter) %>%
  # summarize count
  count() %>% 
  # create area plot
  ggplot(aes(x = chapter, y = n)) +
  geom_area(aes(fill = sentiment), 
  	stat = 'identity') + 
  # add black smoothing line without standard error
  geom_smooth(aes(fill = sentiment), 
  	method = "loess", 
  	se = F, 
  	col = 'black') + 
  # remove legend
  theme(legend.position = 'none', 
        # change font size
        text = element_text(size = fs)) + 
  # add labels
  labs(x = "Chapter", y = "Emotion score", 
       title = "Harry Plotter: Emotions during the saga",
       subtitle = "Using tidytext and the nrc sentiment dictionary") +
  # separate plots per sentiment and book and free up x-axes
  facet_grid(sentiment ~ book, 
  	scale = "free_x") 
