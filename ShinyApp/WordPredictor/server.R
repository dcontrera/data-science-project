#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(xtable)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # 
    # })
    source(
        file = "predict.R",
        local = TRUE
    )
    load("m.RData")
    # print(head(m))
    predMarks <- predMark("", rownames(m), m)
    print(head(predMarks))
    # prediction <- renderTable({
    #     predictWord(predMarks, input$ngram)
    # })
    # print(renderPrint(prediction()))
    # output$prediction <- renderText({ paste(input$ngram, prediction()) })
    # output$prediction <- renderText({
        # paste(input$ngram, predictWord(predMarks, input$ngram), "<br>")
    # })
    predictions <- reactive({predictWord(predMarks, input$ngram)})
    print(renderText({predictions()}))
    predictionsFrame <- function(ngram, predictions) {
        data.frame(input = ngram, prediction = predictions)
    }
    print(renderText({predictionsFrame(input$ngram, predictions())}))
    datar <- reactive({
        predictionsFrame(input$ngram, predictions())
    })
    output$prediction <- renderTable({datar()})
})
