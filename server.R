#+ATTR_LATEX: :options fontsize=\scriptsize 
#+BEGIN_SRC R :eval no :exports code
# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  #output$distPlot <- renderPlot({
  #  x    <- rnorm(1000)
  #  bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #  hist(x, breaks = bins, col = "red", border = "black",
  #       xlab = "Waiting time to next eruption (in mins)",
  #       main = "Histogram of waiting times")
  #  })
  
  output$currValTo <- renderText({
    v = getValueByName(input$currFrom) / getValueByName(input$currTo) * input$currValBase;
    paste(format(v, digits=3))
  })
  
  output$lastUpdate <- renderText({
    paste("Last update: ", getDatabaseDate())
  })
  
  output$fromDate <- renderText({
    paste(input$dateRange[1])
  })
  
  output$toDate <- renderText({
    paste(input$dateRange[2])
  })
  
  
  observeEvent(input$updateButton, {
    updateDatabase()
    output$lastUpdate <- renderText({
      paste("Last update: ", getDatabaseDate())
    })
  })
}
#+END_SRC
