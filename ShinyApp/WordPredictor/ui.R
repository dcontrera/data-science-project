#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Prediction Algorithm"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput("ngram", "Type your n-gram here", "Hello"),
            # verbatimTextOutput("prediction")
            # textOutput("prediction")
            fluidRow(
                column(1,
                       tableOutput('prediction')
                )
            )
        ),
        # Show a plot of the generated distribution
        mainPanel(
            # plotOutput("distPlot")
        )
    )
))
