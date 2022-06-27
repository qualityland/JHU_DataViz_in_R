library(shiny)
library(tidyverse)

# data import

# VERY IMPORTANT: best practice is to have your .csv or other data file
# in the same directory as your .R file for the shiny app.

setwd("~/wrk/studio/JHU_DataViz_in_R/04_pub_viz_with_shiny")
dat <- read_csv("cel.csv")

dat <-
  dat %>%
  mutate(
    Congress = congress,
    Ideology = dwnom1,
    Party = recode(dem, `1` = "Democrat", `0` = "Republican")
  ) %>%
  select(Congress, Ideology, Party) %>%
  drop_na()

# make the static figure for practice - this won't be displayed
ggplot(dat,
       aes(x = Ideology, color = Party, fill = Party)) +
  geom_density(alpha = .5) +
  xlim(-1.5, 1.5) +
  xlab("Ideology - Nominate Score") +
  ylab("Density") +
  scale_fill_manual(values = c("blue", "red")) +
  scale_color_manual(values = c("blue", "red"))

# add facet wrap to see change over time
ggplot(dat,
       aes(x = Ideology, color = Party, fill = Party)) +
  geom_density(alpha = .5) +
  xlim(-1.5, 1.5) +
  xlab("Ideology - Nominate Score") +
  ylab("Density") +
  scale_fill_manual(values = c("blue", "red")) +
  scale_color_manual(values = c("blue", "red")) +
  facet_wrap( ~ Congress)


ui <- fluidPage(

    titlePanel("Ideology in Congress"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("congress",
                        "Congress:",
                        min = 93,
                        max = 114,
                        value = 104)
        ),

        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a density plot
server <- function(input, output) {

    output$distPlot <- renderPlot({
      ggplot(filter(dat, Congress == input$congress),
             aes(x = Ideology, color = Party, fill = Party)) +
        geom_density(alpha = .5) +
        xlim(-1.5, 1.5) +
        xlab("Ideology - Nominate Score") +
        ylab("Density") +
        scale_fill_manual(values = c("blue", "red")) +
        scale_color_manual(values = c("blue", "red"))    })
}

# Run the application 
shinyApp(ui = ui, server = server)
