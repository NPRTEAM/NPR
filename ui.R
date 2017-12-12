#+ATTR_LATEX: :options fontsize=\scriptsize 
#+BEGIN_SRC R :eval no :exports code
library(shiny)

filePath = paste0(getSrcDirectory(function(x) {x}), "/currencyFunctions.R", "")
source(filePath)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  # App title ----
  titlePanel("Currency calculator"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: Slider for the number of bins ----
      selectInput("currFrom", 
                  label = "Choose base currency",
                  choices = getNames(),
                  selected = getNames()[[1]][36],
        ),
      
      numericInput("currValBase", "Value:", 1, min = 1, max = 100),
      
      selectInput("currTo", 
                  label = "Choose target currency",
                  choices = getNames(),
      ),
      
      textOutput("currValTo")
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Histogram ----
      #plotOutput(outputId = "distPlot")
    )
  )
)
#+END_SRC
