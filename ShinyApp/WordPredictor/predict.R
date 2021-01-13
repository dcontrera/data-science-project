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
    if (ngram == "") {
        return("")
    }
    ngram <- tolower(ngram)
    nmax <- max(predMarks$len)
    sp <- strsplit(ngram, " ")[[1]]
    print(sp)
    if (length(sp) > nmax) {
        ngram <- paste(sp[(length(sp) - nmax):length(sp)])
    }
    if (ngram %in% predMarks$hist) {
        hist <- ngram
    } else {
        hist <- "UNK"
    }
    # predMarks$`pred 1`
    # prediction <- predMarks[predMarks$hist == hist, "pred"]
    # if (prediction == "UNK") {
        # prediction <- predMarks[predMarks$hist == hist, "pred 2"]
    # }
    prediction <- predMarks[predMarks$hist == hist, 2:6]
    rownames(prediction) <- "row"
    prediction <- prediction %>% 
        select_if(. != "UNK")
    # print(prediction)
    prediction <- as.character(prediction)
    # print(prediction)
    prediction
}
