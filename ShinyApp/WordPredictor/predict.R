predMark <- function (wi = "", hist, m) {
    if (!any(hist %in% rownames(m))) {hist <- "UNK"}
    rinds <- match(hist, rownames(m))
    if (!any(wi %in% colnames(m))) {wi <- "UNK"}
    if (length(wi) == 1 & wi[1] == "UNK") {
        cinds <- 1:ncol(m)
    } else {
        cinds <- match(wi, colnames(m))
    }
    mhw <- as.matrix(m[rinds, cinds])
    rownames(mhw) <- rownames(m)[rinds]
    colnames(mhw) <- colnames(m)[cinds]
    preds <- unlist(apply(mhw, 1, which.max))
    predTops <- apply(mhw, 1, function (x) {data.frame(Pbo = x) %>% slice_max(n = 5, order_by = Pbo, with_ties = FALSE) %>% rownames()})
    pred <- data.frame(hist = hist[1:length(preds)], pred = colnames(m)[preds])
    if (nrow(predTops) > 1) {
        for (i in 2:nrow(predTops)) {
            pred[ , paste("pred", i)] <- predTops[i, ][1:length(preds)]
        }
    }
    pred$len <- sapply(pred$hist, function (x) {
        length(strsplit(as.character(x), " ")[[1]])
    })
    pred
}
# predMarks <- predMark("", rownames(m), m)
# predMarks
predictWord <- function (predMarks, ngram) {
    prediction <- list()
    prediction$word <- c()
    prediction$hist <- c()
    if (ngram == "") {
        # return(
        #     prediction
        # )
        ngram <- "UNK"
    }
    ngram <- tolower(ngram)
    ngram <- trimws(ngram)
    ngram <- gsub("'", " ", ngram)
    nmax <- max(predMarks$len)
    sp <- strsplit(ngram, " ")[[1]]
    # print(sp)
    # if (length(sp) > nmax) {
        # ngram <- paste(sp[(length(sp) - nmax):length(sp)])
    # }
    # if (ngram %in% predMarks$hist) {
    #     hist <- ngram
    # } else {
    #     hist <- "UNK"
    # }
    found <- FALSE
    nlen <- length(sp)
    while (nlen > 0 & !found) {
        sp_slice <- sp[(length(sp) + 1 - nlen):length(sp)]
        ngram <- Reduce(paste, sp_slice)
        if (ngram %in% predMarks$hist) {
            hist <- ngram
            found <- TRUE
        }
        nlen <- nlen - 1
    }
    if (!found) hist <- "UNK"
    # print(hist)
    # predMarks$`pred 1`
    # prediction <- predMarks[predMarks$hist == hist, "pred"]
    # if (prediction == "UNK") {
        # prediction <- predMarks[predMarks$hist == hist, "pred 2"]
    # }
    pred <- predMarks[predMarks$hist == hist, 2:6]
    for (c in colnames(pred)) {
        pred[ , c] <- as.character(pred[ , c])
    }
    rownames(pred) <- "row"
    pred <- pred %>% 
        select_if(. != "UNK")
    pred <- unlist(pred)
    # print(pred)
    # print(prediction)
    if (hist == "UNK") hist <- "-"
    prediction$word <- pred
    prediction$hist <- hist
    # print(prediction)
    prediction
}

getProbs <- function (hist, word, m) {
    frame <- data.frame(hist = hist, word = word)
    frame$probs <- 0
    for (i in 1:length(frame$hist)) {
        # print(hist)
        # print(word[[i]])
        frame$probs[i] <- m[hist, word[[i]]]
    }
    frame$probs <- frame$probs/(sum(frame$probs))
    frame <- frame %>% 
            arrange(-probs) %>% 
            mutate(word = factor(word, word))
    frame
}

