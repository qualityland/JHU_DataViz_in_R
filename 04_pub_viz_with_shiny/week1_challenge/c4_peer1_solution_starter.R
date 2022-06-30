library(shiny)
library(tidyverse)

# import Data

dat <-
  read_csv(
    url(
      "https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"
    )
  )

dat <- dat %>% select(c("pid7", "ideo5"))
dat <- drop_na(dat)

ui <- fluidPage(

  # sidebar layout
  sidebarLayout(
    # sidebar panel
    sidebarPanel(
      # slider
      sliderInput("ideology",
                  "Select Five Point Ideology (1=Very liberal, 5=Very conservative):",
                  min = 1,
                  max = 5,
                  value = 3)
    ),
    
    # main panel
    mainPanel(
      plotOutput("barPlot")
    )
  )
)

server <- function(input, output) {
  output$barPlot <- renderPlot({
    # draw the scatter plot for selected group
    ggplot(filter(dat, ideo5 == input$ideology),  # group filter
           aes(x = pid7)) +
      geom_bar() +
      labs(x = "7 Point Party ID, 1=Very D, 7=Very R",
           y = "Count")
  })
  
}

shinyApp(ui, server)
