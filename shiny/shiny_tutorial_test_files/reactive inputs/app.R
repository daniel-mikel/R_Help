library(shiny)
ui <- fluidPage(
  numericInput("num", "Input Maximum Slider Value", 5),
  uiOutput("slider")
)

server <- function(input, output) {
  output$slider <- renderUI({
    sliderInput("slider", "Your Slider", min = 0,
                max = input$num, value = 0)
  })
}

shinyApp(ui = ui, server = server)