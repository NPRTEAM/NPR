#+ATTR_LATEX: :options fontsize=\scriptsize 
#+BEGIN_SRC R :eval no :exports code
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  output$currValTo <- renderText({
    v = getValueByName(input$currFrom) / getValueByName(input$currTo) * input$currValBase;
    paste(format(v, digits=3))
  })
  
  output$lastUpdate <- renderText({
    paste("Ostatnia aktualizacja: ", getDatabaseDate())
  })
  
  output$fromDate <- renderText({
    paste(input$dateRange[1])
  })
  
  output$toDate <- renderText({
    paste(input$dateRange[2])
  })
  
  output$currencyPlot <- renderPlotly({
    shiny::validate(
      shiny::need(length(input$plotCurr)>0,"Wybierz co najmniej jedną walutę"),
      shiny::need(('polski złoty' %in% input$plotCurr) == FALSE,"Nie można wybrać Polskiego Złotego, gdyż jest on walutą bazową"),
      shiny::need(input$dateRange[1]<input$dateRange[2],"Błędny format zakresu dat"),
      shiny::need(input$dateRange[2]<=as.Date(getDatabaseDate()), "Nie zaimplementowano funkcji jasnowidza"),
      shiny::need(input$dateRange[2]-input$dateRange[1]<=365,"Wykres może być narysowany tylko dla rocznego zakresu dat")
    )
    dataFrame <- getPlotDataframe(input$plotCurr, paste(input$dateRange[1]), paste(input$dateRange[2]))
    ggplot(dataFrame, aes(x = Data, y = Wartość, color = Waluta)) + geom_line() +
    labs(x = "Data", y = "Wartość", title = "Wykres walut") +
    scale_color_hue("Waluta", l = 70, c = 150)
  })
  
  observeEvent(input$updateButton, {
    updateDatabase()
    output$lastUpdate <- renderText({
      paste("Ostatnia aktualizacja: ", getDatabaseDate())
    })
  })
}
#+END_SRC
