library(maps)
library(mapproj)
library(shiny)
library(ggplot2)
load("FlightDataClean.Rda")
load("AirportLatLonKey.Rda")
ui <- fluidPage(
  titlePanel("Flight Emissions Stats"),
  plotOutput("DestFreq"),
  fluidRow(column(12, h4("Distance"),
  sliderInput("Distance",h3("Flight Distance Input"), min =0,max = 8809, value = c(0,8809),width="100%")) 
), br()    )
  
   

# Define server logic ----
server <- function(input, output) {
  State <- map_data("state")
  World <- map_data("world")
  G <- ggplot() + geom_polygon(
    data = State,
    aes(x = long, y = lat, group = group),
    fill = "grey96",
    color = "grey45"
  ) + coord_fixed(1.3, xlim = c(-122.5,-68), ylim = c(25, 50)) + theme_bw()
  G2 <- ggplot() + geom_polygon(
    data = World,
    aes(x = long, y = lat, group = group),
    fill = "grey96",
    color = "grey45"
  ) + coord_fixed(1.3) + theme_bw()
  
  output$DestFreq <- renderPlot({
    FlightDataInst=FlightData[FlightData$DistInd<=input$Distance[2]&FlightData$DistInd>=input$Distance[1],]
    G+geom_point(data=FlightDataInst, aes(x= FirstLong, y=FirstLat), point=.5)+geom_point(data=FlightDataInst, aes(x= SeconLong,y=SeconLat),point=.5)
  })
  

  
}

# Run the app ----
shinyApp(ui = ui, server = server)