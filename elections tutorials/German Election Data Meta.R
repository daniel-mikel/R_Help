#German Election Data

#the polls on who you are voting for are called in Germany: "Sonntagsfrage"

#this website gives an overview of the main institutes and polls http://www.wahlrecht.de/umfragen/

#this is for local state elections http://www.wahlrecht.de/umfragen/landtage/index.htm 
  #but there is another one for a "federal level divided by regions"

#http://www.wahlrecht.de/umfragen/landtage/index.htm
  #loads of data here


#shape file from http://www.diva-gis.org/datadown 
  #might be German sub region  

  #Germany whole country
D_Temp <- "/home/dan/R Projects/Elections/Map Files/Germany Shape File (subreagional level)/DEU_adm0/DEU_adm0.shp"
DSF0 <- read_shape(file=D_Temp)
qtm(DSF0)

  #Germany States
D_Temp <- "/home/dan/R Projects/Elections/Map Files/Germany Shape File (subreagional level)/DEU_adm1/DEU_adm1.shp"
DSF1 <- read_shape(file=D_Temp)
qtm(DSF1)

  #Germany States -1 (substates?)
D_Temp <- "/home/dan/R Projects/Elections/Map Files/Germany Shape File (subreagional level)/DEU_adm2/DEU_adm2.shp"
DSF2 <- read_shape(file=D_Temp)
qtm(DSF2)

#Germany States -2 (subsubstates?)
D_Temp <- "/home/dan/R Projects/Elections/Map Files/Germany Shape File (subreagional level)/DEU_adm3/DEU_adm3.shp"
DSF3 <- read_shape(file=D_Temp)
qtm(DSF3)



