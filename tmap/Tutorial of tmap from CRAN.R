#https://cran.r-project.org/web/packages/tmap/vignettes/tmap-nutshell.html

#Libraries
library("tmap")

#Data
  #embedded in package tmap
data(Europe)

  #shape files also embedded in package tmap
qtm(Europe)

  #data structure
glimpse(Europe)

#first qtm() projection, a lot of things happneing here
  # Europe calls the dataset, if is listed first
  # fill= calls the column header for the expressed data, attached to "Europe"
  # text= calls the text superimposed on map, here the three letter country identifiers 
  # text.size= calls the size of text
      #here "AREA" is called, which is data not linked to the shp file denoting country size
  # format= there are different built in projections for certain map formats, might only be available for prebuilds
  # style= calls one of a number of prebuilt fill settings, determines how to color areas not colored by your dataset
  # text.root= ?
  # fill.title= title of the legend denoting map colors
  # fill.textNA= specifies a column value that precludes a subcatagory of the data from being graphed
  #
  #
qtm(Europe, fill="well_being", text="iso_a3", text.size="AREA", format="Europe", style="gray", 
    text.root=5, fill.title="Well-Being Index", fill.textNA="Non-European countries")


