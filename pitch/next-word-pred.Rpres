Next Word PredictR
========================================================
author: Benedict Neo
date: 16th November, 2021
autosize: true
class: smaller

Data Science Specialization Capstone Project<br />
Johns Hopkins University<br />


========================================================
# **About**

<small>
This presentation features the Next Word PredictR, including what model was used, 
how the model works and details about how to use the interface.
works 

Below you can find links to the app and to the source code

<ul>
    <li><a target="_blank" href="https://github.com/benthecoder/next-word-predictor/">source code on Github</a></li>
</ul>

The source code files can be found on GitHub:

<ul>
    <li><a target="_blank" href="https://benthecoder.shinyapps.io/Next-Word-PredictR/">Shiny App</a></li>
</ul>

</small>

========================================================
# **Markov Chains**

<small>
Markov chains are a way to model events with discrete states with defined probabilities of moving between states. 

Take the weather for example, if it rained yesterday, we have a discrete state with defined probability of raining yesterday, and raining today. 


<img width=300px height = 300px src="images/markov-weather.png">
</small>


========================================================
# **Markov chain for next word prediction**

<small>
The predictive text model was built from a sample of 200k lines extracted from a random sample of a large corpus of blogs, news and twitter data (over 4 million lines).

The sample data was tokenized and cleaned with tidytext. Cleaning process included removing profane words, all non-ascii characters, and all words were lowercased. The strings were then split into tokens (n-grams).

The markov model was built using the `markovchain` package, and it utilizes only the unigrams due to resource limitations of the shiny app.
</small>

========================================================
# **The Shiny App**

<small>
A picture of the shiny app is below.

Users will enter a text on a textbox on the left side and the predicted words 
are on the right side in a box. Users can also select the number of words they want to predict by inputting in the amount of words below the textbox.

<img src="images/app.png">



