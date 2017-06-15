###tutorial and proofs of concept for rvest
# NOTE html() has changed and is now read_html(), the former was present in nearly all tutorials and has been changed here
# a CSS selector like SelectorGadget may be useful, to pinpoint the sections of html code to download (http://selectorgadget.com/)
# a tutorial on selectors can also be found here: http://flukeout.github.io/#

### FIND PACKAGE scrapeR 

#(1)
### http://www.computerworld.com/article/2909560/business-intelligence/web-scraping-with-r-and-rvest-includes-video-code.html
library("rvest")
htmlpage <- read_html("http://forecast.weather.gov/MapClick.php?lat=42.31674913306716&lon=-71.42487878862437&site=all&smap=1#.VRsEpZPF84I")
forecasthtml <- html_nodes(htmlpage, ".forecast-text")

# this gives just the text of each of the html nodes, without the html script
forecast <- html_text(forecasthtml)

# this gives the "forecast" result as a single string
paste(forecast, collapse =" ")



#(2)
### https://blog.rstudio.org/2014/11/24/rvest-easy-web-scraping-with-r/
library("rvest")

#here we'll fetch from the imdb lego movie. 

#first we need to download and parse the file with html()
lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")

#to extract certian data, it may be useful to use a CSS selector like 'selectorgaget'
#We use html_node() to find the first node that matches that selector, 
  #extract its contents with html_text(), and convert it to numeric with as.numeric()
lego_movie %>% 
  html_node("strong span") %>%
  html_text() %>%
  as.numeric()

# We use a similar process to extract the cast, using html_nodes() to 
  # find all nodes that match the selector: 

lego_movie %>%
  html_nodes("#titleCast .itemprop span") %>%
  html_text()

#The titles and authors of recent message board postings are stored in a the third 
  #table on the page. We can use html_node() and [[ to find it, then coerce it to a 
  #data frame with html_table():

lego_movie %>%
  html_nodes("table") %>%
  .[[3]] %>%
  html_table()



#(3)
#http://zevross.com/blog/2015/05/19/scrape-website-data-with-the-new-r-package-rvest/
library(dplyr)
library(rvest)
library(ggmap)
library(leaflet)
library(RColorBrewer)

# URL for the Visit Ithaca website, wineries page, there is a list of wineries where we can extract addresses
url <- read_html("http://www.visitithaca.com/attractions/wineries.html")

# next we need to find which parts of the html code to extract, often the trickiest part
# fn + f12 button on Firefox, then use the top left tool in the top toolbar
  # this will let you hover over elements in the html code and you can find out how your targets are 'called'

# Pull out the names of the wineries and breweries
# Find the name of the selector (which has changed since the tutorial was first written)
selector_name<-".indSearchListingTitle"

fnames<-html_nodes(x = url, css = selector_name) %>%
  html_text()

# next we want the addresses, this can be pretty tricky, the address is embedded in a bunch of other material
  # we'll need to tell R how to find this within a table of 3 elements. 
  # [this section confused me, refer back to tutorial is drawing information is complicated from HTML CSS]
selector_address<-".indSearchListingMetaContainer div:nth-child(2) div:nth-child(1) .indMetaInfoWrapper"

faddress<-html_nodes(url, selector_address) %>%
  html_text()

# now we need to clean up the addresseses for our future DF, deletes a lot of trash we pulled  on faddress
to_remove <- paste(c("\n", "^\\s+|\\s+$", "on the Cayuga Lake Wine Trail, ",
                   "Cayuga Lake Wine Trail, ", "on the Cayuga Wine Trail, ", 
                   "on the Finger Lakes Beer Trail, "), collapse="|")

faddress <- gsub(to_remove, "", faddress)

# Now we utilize ggmap, using output="latlona" seems to turn our addresses into GPS values
geocodes<-geocode(faddress, output="latlona")
head(geocodes)

# Now we clean up output data for capital letters, if the location is a winery/brewer/etc. [also utilize dplyr]
  # NONE OF THIS WORKS, seems to just be cleaning stuff up until next comment. However, causes everything to break down
  
capwords<-function(s, strict = FALSE) {
  cap<-function(s) paste(toupper(substring(s, 1, 1)),
                         {s<-substring(s, 2); if(strict) tolower(s) else s},
                         sep = "", collapse = " " )
  sapply(strsplit(s, split = " "),
         cap, USE.NAMES = !is.null(names(s)))
}


full<-mutate(geocodes, name=fnames) %>%
  mutate(category=ifelse(grepl("Winery", name), 1, 2)) %>%
  mutate(addressUse=gsub("Ny", "NY", capwords(gsub(", usa", "", address)))) %>%
  mutate(street=sapply(strsplit(addressUse, ","), "[[", 1)) %>%
  mutate(city=sapply(strsplit(addressUse, ","), "[[", 2)) %>%
  filter(!grepl('Interlaken|Ithaca|Aurora|Seneca Falls', street)) %>%
  select(name, street, city, category, lat, lon)

# Here we map the data!
  # chose color scheme 
cols<-colorFactor(c("#3F9A82", "#A1CD4D", "#2D4565"), domain = full$category)

  # Create the popup information with inline css styling
popInfo<-paste("<h4 style='border-bottom: thin dotted #43464C;
    padding-bottom:4px; margin-bottom:4px;
    font-family: Tahoma, Geneva, sans-serif;
    color:#43464C;'>", full$name, "</h4>
    <span style='color:#9197A6;'>", full$street, "<br>",
               paste(full$city, ", NY", sep=""), "</span>", sep="")


  # Create the final map color-coded by type!
leaflet(data=full, height="650px", width="100%") %>%
  addCircles(lat = ~ lat, lng = ~ lon, color = ~cols(category), weight=2, opacity=1,
             fillOpacity=0.6, radius=500, popup = popInfo) %>%
  addTiles("http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%
  setView(-76.63, 42.685, zoom=10) %>% addLegend(
    position = 'bottomright',
    colors = cols(1:2),
    labels = c("Winery", "Brewery, Cidery, Other"), opacity = 1
  )




### http://stat4701.github.io/edav/2015/04/02/rvest_tutorial/
  # this gives a tutorial on scrapping from more 'interactive' sites, won't be done here



