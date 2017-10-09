# tutorial:
  # http://deanattali.com/blog/building-shiny-apps-tutorial/



# 1
  # install and test shiny

library(shiny)
runExample("01_hello") # test that the library is properly functioning

library(ggplot2)
library(dplyr)

# 2
  # shiny app basics

# every shiny app has two parts
  # web page (UI, user interface)
    # shows the app to the user
    # written with shiny functions
    # shows the web page what to display as the user interacts with it
  # computer
    # powers the app
    # can be your computer or a server somewhere else
  # you will need to write both parts



# 3 
  # all shiny appsfollow the same template
    # this template is minimal
      # just opens an empty UI and an empty server
      # runs an app using empty parts
    # copy this template into a new file named "app.R" in a new folder
      # it is very important that this file is called "app.R" 
        # otherwise it would not be recognized as a shiny app
      # the line: shinyApp(ui = ui, server = server) needs to be the last line of the file
      # it is good practice to place this app in its own folder
        # unless the other files in the folder are used in the app

library(shiny)
ui <- fluidPage()
server <- function(input, output){}
shinyApp(ui = ui, server = server)

# after you save the file as "app.R" Rstudio will recognize this as a shiny app
  # you'll also see the usual 'Run App' button change
    # if not, you either:
      # have a very old version of Rstudio
      # have not followed the naming conventions

# after clicking the 'Run App' button, you'll notice you can't change anything
  # R is busy powering your shiny app 
    # and waiting for user interaction through the shiny interface



# 3.1
  # alternative way to create a shiny app | sperate UI and server files

# if you have more complicated shiny apps
  # create seperate ui.R and server.R files
  # for now we'll stick to a single file
  # if you use the ui.R and server.R files in their own folder
    # Rstuddio will recognize their writing a shiny app
    # if using this method, you do not need the shinyApp(ui = ui, server = server) line

# if you create a shiny app like this:
  # replicates the code form (3)
  # even if they are blank files
  # Rstudio will understand the rest



# 3.2
  # let Rstudio fill out a shiny app template for you

# can also create a shiny app with File > New File > Shiny Web App
  # Rstudio will let you chose a single file app (app.R) or a two file app (ui.R + server.R)



# 4
   # load the dataset

# download the file from the destination below
  # place it in the same folder as your Shiny App

# note that importing the dataset doesn't allow it to interact with shiny
  # that will happen later



# 5
  # build the basic UI

# now we'll populate our app with some visual elements
  # this is usually the first thing to do when writing a shiny app



# 5.1
  # add plain text to the UI  

# you can place R strings inside a fluidPage() to render text
  # as in

fluidPage("BC Liquor Store", "Prices")

# replace the line in the template with fluidPage into ui, then run the app to see



# 5.2
  # add formatted text and other HTML elements

# shiny has many fucntions that are wrappers around HTML text
  # h1() is a wrapper for the HTML's  top level header <h1>
  # h2() is a wrapper for the secondary HTML header <h2>
  # strong() to make bold text (<strong> in HTML)
  # em() to make italicized text (<em> in HTML)
  # etc.

# there are also functions that are wrappers to other HTML tags
  # br() for a line break
  # img() for an image
  # a() for a hyperlink
  # etc.

# all of these functions are just wrappers for other HTM tags
  # you can add any arbitrary HTML tag using the 'tags' object
    # learn more by reading the help file on 'tags'
  # as an example, replace your fluidPage() function in your UI with:

fluidPage(
  h1("My app"),
  "BC",
  "Liquor",
  br(),
  "Store",
  strong("prices")
)

# now run the above code and note the formatting 

# for people who know basic HTML:
  # any named argument you pass to an HTML function 
    # becomes an attribute of the HTML element
  # any unnamed argument will be a child of the element
  # that meand you can, for example, create the blue text with: 
    # div("this is blue", style = "color: blue;")



# 5.3
  # add a title 

# we can add a title to the app with the h1() function
  # or use titlePanel()
    # this adds a visibly large title-like text to the top of the page
    # ALSO sets the "official" title of the web page
      # including in the browser tab

# from:
ui <- fluidPage(
  h1("My app"),
  "BC",
  "Liquor",
  br(),
  "Store",
  strong("prices"))

# to 
ui <- fluidPage(
  titlePanel("My app"),
  "BC",
  "Liquor",
  br(),
  "Store",
  strong("prices"))

# titlePanel()
  # has a second argument 'windowTitle'
    # determines the title that should be displayed by the browser window



# 5.4
  # add a layout

# sidebarLayout() adds a structure to the shiny app
  # provides a two column layout with a small sidebar and larger main panel
  # we'll build the app such that:
    # all our user inputs will be in the sidebar
    # all the results will be in the main panel on the right
  # sidebarLayout() can be used as:

ui <- fluidPage(
  titlePanel("My app"),
  sidebarLayout(
    sidebarPanel("our inputs will go here"),
    mainPanel("the results will go here")
  ),
  "BC",
  "Liquor",
  br(),
  "Store",
  strong("prices")
)

# additionally, more complex layouts can be achieved with fluidRow() and ?column

# 5.4
  # all UI functions are simply HTML wrappers

# remember that shiny is just a wrapper, and everything in the UI in HTML
  # you can see this by printing the object saved from the fluidPage() function

print(ui)



# 6
  # add inputs to the UI

# shiny has various ways for the user to interact with the shiny app
  # textInput() allows the user to enter text
  # numericInput() lets the user select a number
  # dateInput() is for selecting a date
  # selectInput() is for selecting a box (or a dropdown menu)

# input functions
  # all have the same first two arguments
    # inputId - the name that Shiny will refer to the input when you want to retrieve its current value
      # every input must have a unique inputId
    # label
      # specifies the text in the display label that goes with the input widget
  # every input can also have multiple other arguments specific to that input type



# 6.1
  # input for price

# the first input we have to specify is the price range
  # easiest to use either a numericInput() or a sliderInput()
    # since both are used for selecting numbers
  # if we use numericInput() we'll have to use two inputs
    # one for the minimum and maximum values
  # sliderInput() requires a vector of length two as the value argument, for the range

# we'll use a max value of $100 for the slider
  # covers ~85% of the products in the dataset

sliderInput("priceInput", "Price", min = 0, max = 100,
            value = c(25, 40), pre = "$")



# 6.2
  # input for product type

# we'll use radio buttons as an input functinos
  # to filter the data
  # now our app looks like:

ui <- fluidPage(
  titlePanel("My app"),
  sidebarLayout(
    sidebarPanel(sliderInput("priceInput", "Price", min = 0, max = 100,
                             value = c(25, 40), pre = "$"),
                 radioButtons("typeInput", "Product type",
                              choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                              selected = "WINE")),
    mainPanel("the results will go here")
  )
)

# 6.3
  # input for country

# we'll also add a selector for country
  # using the selectInput() 



# 7
# add placeholders for outputs

# now we need to add elements to the UI to display the outputs
  # these can be a plot, table, or text
  # since we're still building the UI, we can only add placeholders for the outputs
  # each output will need to be constructed in the server code later

# Shiny provides several output functions
  # one for each type of output
  # all output functions have an 'outputId' argument
      # this is used to identify each output



# 7.1
  # output for a plot of the results

# at the top of the main panel we'll have a plot of the results
  # we'll use the function plotOutput()
  # for not, we'll add:
plotOutput("coolplot")
  # to the mainPanel() as a placeholder



# 7.2
  # Output for a table summary

# below the plot, we'll have a table with the results
  # to get a table, we'll use the tableOutput() function
  # add this to mainPanel()
    # maybe with [a few] br() to seperate the two outputs



# 8
  # checkpoint

# now our code should look like:
library(shiny)
bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      radioButtons("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE"),
      selectInput("countryInput", "Country",
                  choices = c("CANADA", "FRANCE", "ITALY"))
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br(),
      tableOutput("results")
    )
  )
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)



# 9
  # implement server logic to create outputs

# so far we've only written inside the 'ui' variable (or in the ui.R script)
  # now we'll have to write the 'server' function

# the server function always has at least two arguments
  # input 
    # a list you will read values from
    # contains all the values of all the different inputs at any given time
  # output
    # a list you will write values to
    # output is where you will save the output objects to display on your app



# 9.1
  # building an output

# we created two placeholders in the ui
  # coolplot (a plot), and results (a table)

# there are three rules to build an output
  # 1
    # save the output ovject into the 'output' list
      # remember that every function has an 'output' argument
  # 2 
    # build the object with the render*() function
      # where the * is the type of output
  # 3
    # acces the input values using the 'input' list
      # every server function has an 'input' argument
    # this is only required if your if you want your output to depend on some input


# we'll create a plot and send it to the coolplot output

output$coolplot <- renderPlot({
  plot(rnorm(100))
})

# the above code shows the first two rules:
  # we've created a plot with renderPlot()
    # which we assigned to coolplot in the output
  # remember that each output created in teh UI must have a unique ID
    # in order to attach an R object to an output ID x, we assignt he R object to output$x
  # NOTE: coolplot was defined as plotOutput(), we must use the renderPlot() function to create the plot

# Note: the code inside renderPlot() doesn't have to be only one line
  # it can be as long as you want, as long as it returns a plot
  # can use library(ggplot2)!!



# 9.2
  # making an output react to an input

# instead of using a static plot, lets use the minimum price selected as the number of points to show
  # this is illistrative, not great to use a slider for this
  # enter the following text in the server function

output$coolplot <- renderPlot({
  plot(rnorm(input$priceInput[1]))
})

# now changing the slider will update the plot!
  # with the minimum slider changing the number of generated random points

# just like output contains a list of outputs, input does the same with inputs
  # whenever the user maniputlates the slider in the app, these values are updated
  # as a slider, this object is a vector of length() = 2



# 9.3
  # building the plot output

# we'll now build a histogram of the bcl data:
  # the following code will run the histogram
    # but won't interact with the input functions

output$coolplot <- renderPlot({
  ggplot(bcl, aes(Alcohol_Content)) +
    geom_histogram()
})

# recall our three inputs: priceInput, typeInput, and countryInput
  # we can filter these based on the values of the inputs
  # we'll use library(dplyr)

# our code now looks like:

library(shiny)
library(ggplot2)
library(dplyr)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      radioButtons("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE"),
      selectInput("countryInput", "Country",
                  choices = c("CANADA", "FRANCE", "ITALY"))
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br(),
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$coolplot <- renderPlot({
    filtered <-
      bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
    ggplot(filtered, aes(Alcohol_Content)) +
      geom_histogram()
  })
}

shinyApp(ui = ui, server = server)


# building the output table

# the other output we have is called results
  # this will be a table of all the products that match the filters
  # we'll use renderTable()
    # returns table as a data.frame
  # you don't need commas between server objects for some reason...





# 10
  # reactivity 101

# shiny uses reactive programing
  # outputs react to changes in inputs
  # as independent variables get updated, dependent variables also get updated




# 10.1
  # creating and accessing reactive variables

# reactive variables can only be used inside reactive contexts!!!!
  # e.g. render*() functions
  # also works with reactive({}) and observe({})
  # accessing a reactive variable outside of a reactive context will give a message:
    # Operation not allowed without an active reactive context. 
    # ...(You tried to do something that can only be done 
    # ...from inside a reactive expression or observer.)

# instead of accessing the reactive variable with print(input$priceInput)
  # use observe({ print(input$priceInput) })
  # since this function can recieve reactive variables
  # often you'll want to know what a reactive variable holds
  # so remember to wrap the cat(input$x) or print(input$x) with an observe({})

# if you want to manipulate a reactive variable, you'll need to use reactive({})
  # for example, if you want to manipulate a reactive input variable before processing
  # otherwise the reactive value changes won't make it 'downstraem'



# 10.2
  # using reactive variables to reduce code duplication

# you may have noticed that the previoius code we filtered the data set the same way in two places
  # once in each render*() function
  # we can reduce this duplicaiton by utilizing the reactive ({}) command

filtered <- reactive({
  bcl %>%
    filter(Price >= input$priceInput[1],
           Price <= input$priceInput[2],
           Type == input$typeInput,
           Country == input$countryInput
    )
})

# the object 'filtered' is doing the exact same thing as previously 
  # except now its wrapped in reactive({}) instead of in each render*()
  # so instead of this in the server.R:

server <- function(input, output) {output$coolplot <- renderPlot({
  filtered <-
    bcl %>%
    filter(Price >= input$priceInput[1],
           Price <= input$priceInput[2],
           Type == input$typeInput,
           Country == input$countryInput
    )
  ggplot(filtered, aes(Alcohol_Content)) +
    geom_histogram()
})

output$results <- renderTable({
  filtered <-
    bcl %>%
    filter(Price >= input$priceInput[1],
           Price <= input$priceInput[2],
           Type == input$typeInput,
           Country == input$countryInput
    )
  filtered
})
}

# we now want:
server <- function(input, output) {
  filtered <- reactive({
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
  })
  
  output$coolplot <- renderPlot({
    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram()
  })
  
  output$results <- renderTable({
    filtered()
  })
}

# reminder:
  # shiny creates a dependency tree 
    # with all the reactive expressions to know what value depends on what other value
    # it sees the object 'filtered' as a reactive exprecision that depends on the input variables
      # thus they get revaluated



# 11
  # using uiOutput() to create UI elements dynamically

# another output function we can add to the ui.R is uiOutput()
  # this allows us to create inputs dynamically

# any input that you can normally create in teh UI is created when the app starts
  # and can't be changed
  # but what if one of your inputs depends on another input?
    # this would mean creating inputs dynamically
    # this is what uiOutput() is for!
      # follows same rules as building outputs



# 11.1
  # basic example of uiOutput()

# if we created an app
  # you can see that this lets you manually set the maximum value in the slider input

library(shiny)
ui <- fluidPage(
  numericInput("num", "Maximum slider value", 5),
  uiOutput("slider")
)

server <- function(input, output) {
  output$slider <- renderUI({
    sliderInput("slider", "Slider", min = 0,
                max = input$num, value = 0)
  })
}

shinyApp(ui = ui, server = server)




# 11.2
  # use uiOutput() in our app to populate the countries

# we will use uiOutput() to to polulate the choices for the country selector
  # the country selector currently only holds 3 values that we manually entered
  # instead we could render the country selector in the server
    # and use this data to determine what countries it can have

# first we need to replace teh selectInput("countryInput", ...) in the UI wiht

uiOutput("countryOutput")

# then we need to create the output (which will create a UI element)
  # so add the following code to the server function:

output$countryOutput <- renderUI({
  selectInput("countryInput", "Country",
              sort(unique(bcl$Country)),
              selected = "CANADA")
})

# now if you run the app, you should be able to see all the countries the liquor stores import from



# 11.3
  # errors showing up and quickly disappearing

# in the R console, we have some errors showing up and going away breifly
  # the problem is when the app initialized 'filtered' is trying to access the country input
    # however, the country input hasn't been created yet
  # after shiny finishes loading fully the country input is generated
  # 'filtered' tries accessing it again, but sucessfully this time
  # we have to modify our 'filtered' object
    # so that if the country input doesn't exist, it just returns NULL

filtered <- reactive({
  if (is.null(input$countryInput)) {
    return(NULL)
  }    
  
  bcl %>%
    filter(Price >= input$priceInput[1],
           Price <= input$priceInput[2],
           Type == input$typeInput,
           Country == input$countryInput
    )
})

# but we still get an error because of renderPlot() and ggplot, so we have to modify:

output$coolplot <- renderPlot({
  if (is.null(filtered())) {
    return()
  }
  ggplot(filtered(), aes(Alcohol_Content)) +
    geom_histogram()
})



# in case you got lost:
  # the final shiny app code

library(shiny)
library(ggplot2)
library(dplyr)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
      radioButtons("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE"),
      uiOutput("countryOutput")
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br(),
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })  
  
  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }    
    
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
  })
  
  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram()
  })
  
  output$results <- renderTable({
    filtered()
  })
}

shinyApp(ui = ui, server = server)



# 13
  # share your app with the world

# remember that every single app is a wabe page powered by an R session on a computer
  # so far we are running shiny locally
  # means your computer was being used to power the app
  # so the app is not accesible to anyone on the internet
  # if you want to share your app, you need to host it somewhere



# 13.1  
  # host on shinyapps.io

# Rstudio provides a service called shinyapps.io
  # lets you host your apps for free
  # integrated to Rstudio
    # can publish your apps with the click of a button, and has a free version
  # however, only allows a certian number of apps per user 
    # and a certain number of activity on each app

# hosting your app on shinyapps.io is recommended to get your app online
  # go to www.shinyapps.io and sign up for an account
  # when your ready to publish, click on the "Publish Application" button on Rstudio
    # then follow the instructions



# 13.2
  # host on a shiny server

# there are other options for hosting your app on its own private shiny server
  # shiny server is also a product by Rstudio that lests you host apps on your own server
    # this gives you a lot more flexibility, but also means you need to have a server
      # and be comfortable administering a server
  # if you want to host on your own private server, there is a tutorial:
    # http://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/


# 14
  # more shiny features to check out



# 14.1 
  # shiny in Rmarkdown

# can include shiny inputs and outputs in an Rmarkdown document
# makes the Rmarkdown document interactive



# 14.2
  # user conditionalPanel() to conditionally show UI elements

# conditionally hide UI elements based on conditions(s)
  # such as the value of the input

library(shiny)
ui <- fluidPage(
  numericInput("num", "Number", 5, 1, 10),
  conditionalPanel(
    "input.num >=5",
    "Hello!"
  )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)



# 14.3
  # use navbarPage() or tabsetPanel() to have multiple tabs in the UI

# uf tiyr aoos requires more than a single 'view' you can have seperate tabs
  # learn more with '?navbarPage' or '?tabsetPanel'

library(shiny)
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Tab 1", "Hello"),
    tabPanel("Tab 2", "there!")
  )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)



# 14.4 
  # use DT for beautiful, interactive tables

# whenever you use tableOutput() + renderTable() the shiny table is pretty bland
  # with library(DT) you can replace the defualt table with a much cleaner table
    # DT::dataTableOutput() + DT::renderDataTable()
  # this is actually really sweet and easy to use



# 14.5 
  # use isolate() function to remove a dependency on a reactive variable

# when you have multiple reactive variables inside a reactive context
  # the whole code block will get reexecuted whenever any of the reactive variables change
  # is you want to suppress this behavior and cause a reactive variable to not be a dependency
    # wrap the code that uses that variable inside isolate() 
    # any reactive variables inside isolate() will not result in the code re-executing
  # read more with '?isolate'



# 14.6 
  # use update*Input() functions to update input values programmatically

# any input function has an equivalent update*Input function that can be used to update any parameters

library(shiny)
ui <- fluidPage(
  sliderInput("slider", "Move me", value = 5, 1, 10),
  numericInput("num", "Number", value = 5, 1, 10)
)
server <- function(input, output, session) {
  observe({
    updateNumericInput(session, "num", value = input$slider)
  })
}
shinyApp(ui = ui, server = server)



# 14.7
  # scoping rules in shiny apps

# scoping is very important to undersand in shiny 
  # once you want to support more than one user at a time
  # since your app can be hosted online
    # multiple users can use your app simultaneously
  # if there are any variables (such as datasets or flobal parameters)
    # that should be shared by all users
      # you can safely define them globally
    # that should be specific to each user session
      # should not be defined globally

# think of the server function as a sandbox for each user
  # any code outside of the server uction is run once and is shared by all instances of your shiny app
  # any code inside the server is run once for every user that visits your app
    # this means that any user-specific variables should be defined inside of server
  # if you look at the sample app we made with BC Liquor Store
    # you'll see that we followed this rule
    # the raw dataset was loaded outside the server and was available to all users
    # but the 'filtered' object is constructed inside the server
      # so every user has their own version of it
    # if 'filtered' was a global variable, then when one user changes the values in your app
      # all users connected to your app would see the change happen
  # more about scoping here:
    # http://shiny.rstudio.com/articles/scoping.html



# 14.8
  # use global.R to define objects available to both ui.R and server.R

# if there are objects that you want to have available in both ui.R and server.R
  # you can place them in global.R
  # learn more about global.R here:
    # http://shiny.rstudio.com/articles/scoping.html


  
# 14.9 add images
  # you can add an image to your shiny app by placing an image under the www/ folder
  # then using the UI function 

img(src = "image.png")



# 14.10
  # add javascript / CSS

# if you know JavaScript or CSS you are more than welcome to use both in your app
  # check out libarary("shinyjs) for more:
    # https://github.com/daattali/shinyjs

library(shiny)
ui <- fluidPage(
  tags$head(tags$script("alert('Hello!');")),
  tags$head(tags$style("body{ color: blue; }")),
  "Hello"
)
server <- function(input, output) {
  
}
shinyApp(ui = ui, server = server)



# 15
  # asesome add-on packages to Shiny

# library("shinyjs")
  # easily improve the user interaction and user experience 

# library("shinythemes")
  # easily alter the appearence of your app

# library("leaflet")
  # add interactive maps to your apps

# library("ggvis")
  # similar to ggplot2
  # but plots are focused on being web-based and more interactive

# library("shinydashboard)
  # gives ou tools to create visual 'dashboards'



# 16
  # resources

# shiny has lots of resources on the web

# Shiny official tutorial
  # http://shiny.rstudio.com/tutorial/

# Shiny cheatsheet
  # http://shiny.rstudio.com/images/shiny-cheatsheet.pdf

# Lots of short useful articles about different topics in Shiny
 # http://shiny.rstudio.com/articles/

# Shiny in Rmarkdown
  # http://rmarkdown.rstudio.com/authoring_shiny.html

# Get help from the Shiny Google group or StackOverflow
  # https://groups.google.com/forum/#!forum/shiny-discuss
  # https://stackoverflow.com/questions/tagged/shiny

# Publish your apps for free with shinyapps.io
  # http://www.shinyapps.io/

# Host your app on your own Shiny server
  # http://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/

# Learn about how reactivity works
  # http://shiny.rstudio.com/articles/execution-scheduling.html

# Learn about useful debugging techniques
  # http://shiny.rstudio.com/articles/debugging.html

# Shiny tips & tricks for improving your apps and solving common problems
  # http://deanattali.com/blog/advanced-shiny-tips/


# 17
  # ideas to improve your app

# check out the list under 17 on 
  # http://deanattali.com/blog/building-shiny-apps-tutorial/