#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(dplyr)
library(xtable)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

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
    load("predMarks.RData")
    # print(head(m))
    # predMarks <- predMark("", rownames(m), m)
    # print(head(predMarks))
    # prediction <- renderTable({
    #     predictWord(predMarks, input$ngram)
    # })
    # print(renderPrint(prediction()))
    # output$prediction <- renderText({ paste(input$ngram, prediction()) })
    # output$prediction <- renderText({
        # paste(input$ngram, predictWord(predMarks, input$ngram), "<br>")
    # })
    predictions <- reactive({predictWord(predMarks, input$ngram)})
    # print(renderText({predictions()}))
    predictionsFrame <- function(ngram, predictions) {
        # print(predictions)
        df <- data.frame(input = ngram, prediction = predictions)
        # print(head(df))
        df
    }
    # print(renderText({predictions()$word}))
    # print(renderText({predictionsFrame(input$ngram, predictions()$word)}))
    datar <- reactive({
        # predictionsFrame(input$ngram, predictions())
        predictionsFrame(predictions()$hist, predictions()$word)
    })
    probs <- reactive({
        if (length(datar()$input) > 0 & datar()$input[1] != "-") {
            prob <- getProbs(predictions()$hist, predictions()$word, m)
        }
    })
    plotWords <- reactive({
        if (length(probs()$word) > 0) {
            g <- probs() %>% 
                ggplot() + 
                geom_bar(aes(x = word, y = probs, fill = "blue"), stat = 'identity') + 
                scale_y_continuous(labels = scales::percent) +
                # ggtitle("Next Word Probabilities", subtitle = predictions()$hist) +
                ggtitle("Next Word Probabilities") +
                theme(legend.position = "none") +
                theme(axis.text.x = element_text(face = "bold", size = 20))
            g
        }
    })
    output$plotWords <- renderPlot({plotWords()})
    output$prediction <- renderTable({datar()})
    npreds <- reactive({
        if (ncol(datar()) > 0) {
            npreds <- length(datar()[, 1])
        } else {
            npreds <- 0
        }
        npreds
    })
    output$predButtons <- renderUI({
        buttons = tagList()
        for (i in 1:npreds()) {
            buttons[[i]] <- actionButton(
                paste0("action", i), 
                label = paste0(datar()[i, "prediction"]),
                style = "
                    color: green;
                "
            )
        }
        buttons
    })
    # reactive({
        # i <- 3
        # for (i in 1:npreds()) {
        # for (i in 1:10) {
        lapply(1:10, function (i) {
            observeEvent(input[[paste0("action", i)]], {
            # observeEvent(input[["action1"]], {
                # input$ngram <- paste(input$ngram, "good")
                # print("Button", i)
                updateTextInput(session, "ngram", value = paste(input$ngram, datar()[i, "prediction"]))
            })
        })
    # })
    observeEvent(input$reset, {
        # print(input)
        reset("ngram")
    })
    observeEvent(input$delete, {
        sp <- strsplit(input$ngram, " ")[[1]]
        if (length(sp) == 1) {
            rep <- ""
        } else {
            rep <- Reduce(paste, sp[1:length(sp) - 1])
        }
        updateTextInput(session, "ngram", value = rep)
    })
})
