library(shiny)
library(tidyverse)

dat <- read_csv("publish_data.csv")
#dat <- read_csv("04_publish_practice/publish_data.csv")

ggplot(dat, aes(x = varX, y = varY, color = Group)) +
  geom_point()

# Define UI for application that draws a histogram
ui <- fluidPage(

    # title
    titlePanel("Old Faithful Geyser Data"),

    # sidebar with radio buttons 
    sidebarLayout(
        sidebarPanel(
            radioButtons(inputId = "group",
                         label = "Group",
                         choices = c("a", "b", "c"))
        ),

        # show scatter plot
        mainPanel(
           plotOutput("scatterPlot")
        )
    )
)

# server logic
server <- function(input, output) {

    output$scatterPlot <- renderPlot({
        # draw the scatter plot for selected group
        ggplot(filter(dat, Group == input$group),  # group filter
               aes(x = varX, y = varY, color = Group)) +
          geom_point()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
