###############################################
###R Data Visualization: Shiny Apps Practice###
###############################################

#Franco Gigliotti
#03/29/21


#################
###Description###
#################

#This is a simple shiny app that allows the user to plot  specified variables
#from the native r dataset iris against each other on a simple ggplot. The app
#then outputs summary statistics from a linear model that examines the relationships
#between the variables.

###################
###Load Packages###
###################

#install.packages('shiny')
library(shiny)
library(ggplot2)

###########################
###Call Global Variables###
###########################

#Only using I. virginica in this sample
i.virginica <- iris[iris$Species=="virginica",]
vars <- setdiff(names(i.virginica), "Species")
#summary(lm(Sepal.Length ~ Sepal.Width, data = iris))

###########################
###Generate Shiny App UI###
###########################

ui <- fluidPage(
  headerPanel(
    verbatimTextOutput('print')
  ),
  sidebarPanel(
    selectInput('xcol', 'X Variable', vars),
    selectInput('ycol', 'Y Variable', vars, selected = vars[[2]])
  ),
  mainPanel(
    plotOutput('plot')
  )
)

###############################
###Generate Shiny App Server###
###############################

server<-function(input, output) {
 
  # Generate a ggplot of the requested x variable against the 
  # requested y variable
  
  output$plot <- renderPlot({
    
    # select the input variables
    iris.data <- data.frame(xvar = i.virginica[[input$xcol]], 
                            yvar = i.virginica[[input$ycol]])
    
    p <- ggplot() + 
      geom_point(data = iris.data, aes(x = xvar, y = yvar), 
                 color = "gray10", fill = "purple", shape = 24, size = 3) +
      stat_smooth(data = iris.data , method="lm",se=TRUE, size = 0.8,
                  aes(x = xvar, y = yvar), color = "gray30", fill = "light blue") +
      labs(x=input$xcol, y=input$ycol) +
      theme(axis.text = element_text(color = "gray10"),  
            axis.title.x = element_text(vjust = 1, size = 14),
            axis.title.y = element_text(angle = 90, vjust = 1, size = 14),
            panel.background = element_rect(fill = "white", color = NA),
            panel.border = element_rect(color = "gray50", fill = NA, size = 0.5),
            panel.grid.major = element_line(color = "gray80", size = .5),
            panel.grid.minor = element_blank())
    print(p)
    
  })
  
  # Generate summary statistics from the lm
  output$print <-renderPrint({
    iris.data <- data.frame(xvar = i.virginica[[input$xcol]], 
                            yvar = i.virginica[[input$ycol]])
    summary(lm(yvar ~ xvar, data = iris.data))
  })
  
}


#########################
###Generate Shiny App!###
#########################

shinyApp(ui = ui, server = server)
