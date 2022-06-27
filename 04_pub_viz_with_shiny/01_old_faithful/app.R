#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        wait    <- faithful[, 2]
        bins <- seq(min(wait), max(wait), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(
          wait,
          breaks = bins,
          col = 'darkgray',
          border = 'white',
          main = "Histogram of Waiting Time between Eruptions",
          xlab = "Waiting Time (min)"
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
