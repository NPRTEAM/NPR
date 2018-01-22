#+ATTR_LATEX: :options fontsize=\scriptsize 
#+BEGIN_SRC R :eval no :exports code

# do plotly wymagana instalacja "gfortran" i "libssl-dev" poprzez sudo apt-get install
# sam plotly moze wymagac uprzedniej instalacji "openssl", hexbin" i "httr" poprzez install.packages()

library(shiny)

filePath = paste0(getSrcDirectory(function(x) {x}), "/currencyFunctions.R", "")
source(filePath)

ui <- fluidPage(
  navbarPage("Currency Converter",
    tabPanel("Konwerter",
      fixedRow(
        column(width = 4,
          selectInput("currFrom", 
          label = "Waluta bazowa",
          choices = getNames(),
          selected = getNames()[[1]][8])),
      
        column(width = 4, 
          numericInput("currValBase", "Kwota bazowa:", 1, min = 1, max = 1000)),
                  
        column(width = 4,                
          selectInput("currTo", 
          label = "Waluta docelowa",
          choices = getNames(),
          selected = getNames()[[1]][36]))),
                        
      fixedRow(
        br(),
        column(width = 12, h1("Kwota docelowa: "), align="center"), 
        br(),
        column(width = 12, h2(textOutput("currValTo")), align="center"),
        br()),
                        
      fixedRow(
        br(),
        column(width = 12, textOutput("lastUpdate"), align="right"),
        br(),
        br(),
        column(width = 12, actionButton("updateButton", "Aktualizuj"), align="right"))
      
    ),
    
    tabPanel("Wykres",sidebarLayout(
      sidebarPanel(
        selectizeInput("plotCurr", 
                    label = "Wybierz walutę (waluty)",
                    choices = getNames(),
                    selected = getNames()[[1]][1],
                    multiple = TRUE,
                    options = list(maxItems = 5)
        ),
        dateRangeInput('dateRange',
                       label = 'Zakres walut',
                       start = as.Date(getDatabaseDate()) - 10, end = as.Date(getDatabaseDate())
        )
      ),
      mainPanel(
        textOutput("error"),
        plotlyOutput("currencyPlot")
      )
    )
    )
  )
)
#+END_SRC
