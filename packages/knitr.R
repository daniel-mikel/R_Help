#Using Latex within R

#a tutorial is given here https://www.youtube.com/watch?v=LrWBHqN3TUE

#Packages
#knitr allows compiling of Latex within the R enviornment

#! important, you will need to consider some settings when using Latex in R
## firstly go to Tools -> Global Options -> Sweave
## Sweave Rnw files using: [set to] "knitr", not(?) Sweave\
## Typeset Latex into Pdf using: "pdfLatex"
## Always enable Rnw concordence: Check this box

#file name will be changed to .Rnw
## Rnw stands for a way to incoporate R code into Latex (vise versa)

#use "<<>>=" to embed R code into Latex, as:

<<>>=
  
#to get syntax highlighting, file must be saved as a Rnw
  
#!!file names cannot have spaces!!
  