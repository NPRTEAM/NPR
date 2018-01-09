#+ATTR_LATEX: :options fontsize=\scriptsize 
#+BEGIN_SRC R :eval no :exports code

# do plotly wymagana instalacja "gfortran" i "libssl-dev" poprzez sudo apt-get install
# sam plotly moze wymagac uprzedniej instalacji "openssl", hexbin" i "httr" poprzez install.packages()

library(shiny)

filePath = paste0(getSrcDirectory(function(x) {x}), "/currencyFunctions.R", "")
source(filePath)

ui <- fluidPage(
  navbarPage("Currency Converter",
    tabPanel("Calculator",
      sidebarLayout(
        sidebarPanel(
          selectInput("currFrom", 
            label = "Choose base currency",
            choices = getNames(),
            selected = getNames()[[1]][8],
          ),
          numericInput("currValBase", "Value:", 1, min = 1, max = 100),
          selectInput("currTo", 
            label = "Choose target currency",
            choices = getNames(),
            selected = getNames()[[1]][36],
          ),
                          
          textOutput("currValTo"),
          textOutput("lastUpdate"), actionButton("updateButton", "Update")
        ),
        mainPanel()
      )
    ),
    tabPanel("Chart",sidebarLayout(
      sidebarPanel(
        selectInput("baseCurr", 
                    label = "Choose base currency",
                    choices = getNames(),
                    selected = getNames()[[1]][8],
        ),
        selectizeInput("plotCurr", 
                    label = "Choose target currency",
                    choices = getNames(),
                    selected = getNames()[[1]][36],
                    multiple = TRUE,
                    options = list(maxItems = 5)
                    
        ),
        dateRangeInput('dateRange',
                       label = 'Date range',
                       start = as.Date(getDatabaseDate()) - 10, end = as.Date(getDatabaseDate()))
        ,textOutput("fromDate")
        
        
      ),
      mainPanel()
    )
    )
  )
)


  

#+END_SRC
