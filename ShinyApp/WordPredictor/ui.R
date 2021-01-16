#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    useShinyjs(),
    
    # Application title
    titlePanel("Prediction Algorithm"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput("ngram", "Type your n-gram here", "It's a"),
            h5("Choose the next word or keep typing"),
            uiOutput("predButtons"),
            # br(),
            h5("Reset the input panel or delete the last word"),
            actionButton("reset", "Reset", 
                style = "
                    color: red;
                "
            ),
            actionButton("delete", "Delete",
                style = "
                    color: blue;
                "
            )
            # ),
            # br(),
            # fluidRow(
            #     column(1,
            #            tableOutput('prediction')
            #     )
            # )
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plotWords")
        )
    )
))
