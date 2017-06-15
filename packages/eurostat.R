library(eurostat)
library(knitr)


#example
tmp <- eurostat:::get_eurostat_raw("educ_iste")
head(tmp)



#practice data from dataset whose servers are functional
tmp <- search_eurostat("EU trade since 1988 by HS6")
head(tmp)

get_eurostat("DS-016893", time_format = "date", 
             filters = list(EU, MX, G_ALL_HS6, 1, E1, E7, U10, U11, U70, U71, VALUE_IN_EUROS), 
             type = "code", select_time = "Y")

#set up for the data I want, need to change filters
get_eurostat(id, time_format = "date", 
             filters = "none", 
             type = "code", select_time = "Y", update_cache = FALSE,
             cache_dir = NULL, compress_file = TRUE,
             stringsAsFactors = default.stringsAsFactors(), keepFlags = FALSE, ...)

#this lets us find the data something we're looking for, search term maybe?
tmp <- search_eurostat("regime")
head(tmp)
##now we know that desired code=DS-041718 for Adjusted EU-EXTRA imports by tariff regime, by HS6

#building search query
get_eurostat(DS-041718, time_format = "num", )

Terms <- c("Partner", "Reporter", "Period", "Products", "Flow", "Indicators")
