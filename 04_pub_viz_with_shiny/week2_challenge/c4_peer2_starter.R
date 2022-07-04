library(shiny)
library(tidyverse)
library(plotly)
library(DT)

#####Import Data

dat <- read_csv(url("https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"))
dat <- dat %>% select(c("pid7","ideo5","newsint","gender","educ","CC18_308a","region"))
dat <- drop_na(dat)

# make your app

ui <- navbarPage(
  title="My Application",
  tabPanel("Page 1",
    # sidebar layout
    sidebarLayout(
      # sidebar panel
      sidebarPanel(
        # slider
        sliderInput(
          "ideology",
          "Select Five Point Ideology (1=Very liberal, 5=Very conservative):",
          min = 1,
          max = 5,
          value = 3
        )
      ),
       
      # main panel
      mainPanel(
        tabsetPanel(
          tabPanel("Tab1", plotOutput("partyBarPlot")), 
          tabPanel("Tab2", plotOutput("trumpBarPlot"))
        )
      )
    )
  ),
  tabPanel("Page 2",
  ),
  tabPanel("Page 3",
  ),
)

  
  
server<-function(input,output){
  
  # Hint: when you make the data table on page 3, you may need to adjust
  # the height argument in the dataTableOutput function.
  # Try a value of height=500
  
  # partyBarPlot
  output$partyBarPlot <- renderPlot({
    # draw the scatter plot for selected group
    ggplot(filter(dat, ideo5 == input$ideology),  # group filter
           aes(x = pid7)) +
      geom_bar() +
      labs(x = "7 Point Party ID, 1=Very D, 7=Very R",
           y = "Count")
  })
  
  # trumpBarPlot
  output$trumpBarPlot <- renderPlot({
    # draw the scatter plot for selected group
    ggplot(filter(dat, ideo5 == input$ideology),  # group filter
           aes(x = CC18_308a)) +
      geom_bar() +
      labs(x = "Trump Support",
           y = "Count")
  })
  
} 

shinyApp(ui,server)

# Are there three pages to the application?
# On Page 1, is there a tabset with two tabs?
# On Page 1, does the input in the side panel substantially match the model?
# On Page 1, does Tab 1 substantially replicate the figure in the model?
# On Page 1, does Tab 2 substantially replicate the figure in the model?
# On Page 2,  does the input in the side panel substantially match the model?
# On Page 2, does the main panel substantially replicate the figure in the model?
# On Page 3, does the input in the side panel match the model?
# On Page 3, does the main panel substantially replicate the table in the model?
# (Hint: This is a data table)