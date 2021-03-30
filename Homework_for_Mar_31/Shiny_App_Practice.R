###Shiny App Practice###

#################
###Description###
#################

#This code is for practicing generating Shiny Apps in RStudio

##############################
###Load Packages and Set WD###
##############################

#install.packages('shiny')
library(shiny)


###########################
###Generate Shiny App UI###
###########################

ui<-fluidPage(sliderInput(inputId = "num",
                          label = "Choose a Number",
                          value = 25, min = 1, max = 100),
              textInput(inputId = "title",
                        label = "Write a title",
                        value = "Histogram of Random Normal Values"),
              plotOutput("hist")
            )


###############################
###Generate Shiny App Server###
###############################

server<-function(input,output){
  output$hist <- renderPlot({
    hist(rnorm(input$num), main = input$title)
  })
}


#########################
###Generate Shiny App!###
#########################

shinyApp(ui = ui, server = server)
