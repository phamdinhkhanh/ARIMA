library(shiny)
#library(ggplot2)
fluidPage(
  numericInput(inputId = "p",
               value = 1,
               min = 1, max = 4, step = 1,
               width = '50%', label = "Partitial Correlation Degree"),
  numericInput(inputId = "q",
               value = 1,
               min = 1, max = 4, step = 1,
               width = '50%', label = "Auto-correlation"),
  strong("Forecast vs Actual value"),
  tableOutput("comparision"),
  textOutput("accuracy"),
  plotOutput("f"),
  tableOutput("forecast"),
  tableOutput("table"),
  strong("ADF test result"),
  textOutput("adf"),
  plotOutput("p"),
  plotOutput("q")
)


