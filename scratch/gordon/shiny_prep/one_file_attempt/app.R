library(shiny)


ui <- navbarPage("App Title",
           tabPanel("Interactive Map",
                    fillPage(
                       # titlePanel("Uploading Files"),
                       # mainPanel(
                            htmlOutput("map")
                        #)
                    )
                    
                    ),
           tabPanel("Summary")
)



server <- function(input, output) {
    
    getPage<-function() {
        return(includeHTML("webmap.html"))
    }
    output$map<-renderUI({getPage()})
    
}

shinyApp(ui, server)