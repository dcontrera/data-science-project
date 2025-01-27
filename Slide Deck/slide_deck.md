Typing Text Predictor
========================================================
author: Daniel Contrera
date: 16/01/2021
autosize: true
width: 1920
height: 1080
transition: rotate
<style>
.section .reveal h1 {
    color: black;
    font-weight: bold;
}
.reveal h3 {
    color: green;
    font-weight: bold;
}
.section .reveal p {
    color: black;
}
.section .reveal .state-background{
    background-color: #ddffdd;
    background-size: cover;
}
.reveal .controls div.navigate-left, .reveal .controls div.navigate-left.enabled {
    border-right-color: #ff00ff;
}
.reveal .controls div.navigate-right.enabled {
    border-left-color: #ff00ff;
}
.reveal .progress {
    height: 6px;
}
.reveal .progress span {
    background-color: #ff00ff;
}
.footer {
    color: black;
    <!-- background: #110000; -->
    position: fixed;
    top: 90%;
    text-align:center;
    width:100%;
}
</style>

<br>

<center>

![keyboard](keyboard.png)

</center>

Predictive Model
========================================================

- The predictive model I have developed can help you while typing in a keyboard.

- This model has been trained in order to predict the next word you are thinking of.

- It has  high compared with others such as SwiftKey's predictor which is the most know virtual keyboard.

- It can also be trained with your own data and learn your style of writing.

<center>

![plot](plot.png)

</center>

Training
========================================================

- This model have been trained with a large corpus based on news, blogs and tweets.

- It has an accuracy of 87% for the top 1000 n-grams which was measured testing if the predicted word was included in the top 5 most common words for each n-gram in a test set.

- The perplexity of the model, which is how much the model does not understand the words of a new dataset, is quite low. It's only 117.7 when the model is compared with a test set of 400 lines of new text.

- In order to deploy the model in an web application, we limit the amount of word 
that the model knows while keeping the accuracy in a high level.

- The model has learnt the following counts of n-gram:

<center>

|n.gram  |  count|
|:-------|------:|
|word    |  11805|
|bigram  | 395533|
|trigram | 692086|
|4-gram  | 770085|
</center>

Web Application
========================================================

- The model has been published in the Shiny App Server.

- The interface is human friendly and anyone can try some phrases and discover the power of the model.

- Every time the user type a phrase the model instantly put some predictions ordered by probabilities.

- In the example the model, when the input is *It's a* predicts that the next world probably will be *good* or *very*. 

<center>
    ![example](example.png)
</center>

Conclusions
========================================================

- The Text Predictor can be easily developed, trained and deployed.

- It has a high accuracy while it is fast enough to instantly display predictions.

- It can be used in a web page or any place that you need to type something.

- Try it now!: 

[https://dcontrera.shinyapps.io/TypingTextPredictor/](https://dcontrera.shinyapps.io/TypingTextPredictor/)

<center>
    [![App](App.png)](https://dcontrera.shinyapps.io/TypingTextPredictor/)
</center>
