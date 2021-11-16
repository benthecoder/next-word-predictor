# load libraries ---------------------------------------------------
library(shiny)
library(markdown)
library(bslib)

# source code for prediction model --------------------------------
source('scripts/next-word-markov.R')

# UI for shiny -----------------------------------------------------

ui <- fluidPage(navbarPage(
    "Next Word Predictor",
    theme = bs_theme(bootswatch = "minty"),
    tabPanel("Home",
             fluidPage(
                 sidebarLayout(
                     sidebarPanel(
                         textInput(
                             inputId = "str",
                             label = h3("Enter some Text:"),
                             value = "I love"
                         ),
                         numericInput(
                             inputId = "n",
                             label = h3("no. of predictions"),
                             min = 1,
                             max = 20,
                             value = 5,
                             step = 1
                         )
                     ),
                     
                     mainPanel(
                         h2("Predictions 🔮"),
                         h3(textOutput("pred", container = pre))
                     )
                 )
             )),
    tabPanel("How it works",
             includeHTML(
                 "report/markov-chain.html"
             )),
    tabPanel("About the data",
             includeMarkdown(
                 "docs/corpora-info.md"
             )),
    tabPanel("More",
             img(src="nyancat.gif", align = "center", height='300px',width='300px'),
             hr(),
             p("contact me at benthecoder07@gmail.com"),
             tags$a(href="https://www.linkedin.com/in/benedictneo/", "Connect with me on Linkedin"),
             hr(),
             tags$a(href="https://github.com/benthecoder/next-word-predictor", "Source code on Github"),
             ),
))

# server code for shiny --------------------------------------------

server <- function(input, output, session) {
    output$pred <- renderText({
        preds <- next_word(input$str, input$n)
        paste(preds, collapse="\n")
    })
}

# run app --------------------------------------------------------
shinyApp(ui, server)