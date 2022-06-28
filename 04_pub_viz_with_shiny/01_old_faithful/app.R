library(shiny)

# ui
ui <- fluidPage(

    # title
    titlePanel("Old Faithful Geyser Data"),

    # layout 
    sidebarLayout(
        # sidebar
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # main panel
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# server
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # bins / breaks
        wait    <- faithful[, 2]
        bins <- seq(min(wait), max(wait), length.out = input$bins + 1)

        # histogram
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

# run app
shinyApp(ui = ui, server = server)
