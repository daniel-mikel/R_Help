library(dplyr)
library(ggvis)
library(tidyverse)

# import gc 
gc <- read.csv(file = "/home/dan/Data/NASS/Grape_Crush/gc_csv/all_gc_clean.csv", stringsAsFactors = FALSE)
gc$Base.Price.Per.Ton <- as.numeric(gc$Base.Price.Per.Ton)
gc$Brix.Code <- as.numeric(gc$Brix.Code)
gc$Tons <- as.numeric(gc$Tons)
gc$Year <- as.integer(gc$Year)


# Visualize one grape based on filtered criterion
	# either variety or variety and district

gc %>%
	filter(Variety == "cabernet sauvignon") %>%
	ggvis(y = input_select(c('Base.Price.Per.Ton', 'Tons'), map = as.name)) %>% 
 	layer_points(x = ~Year, fill = ~District)

# need to find out how to make interactive parameter for filter variable
  	# so we can make Variety or Distric searchable
  	# could make Distric or Variety into own columns...
