library(maps)
library(mapproj)
library(shiny)
library(ggplot2)
load("FlightDataClean.Rda")
load("AirportLatLonKey.Rda")
ui <- fluidPage(
  titlePanel("Flight Emissions Stats"),
  plotOutput("DestFreq"),
  fluidRow(column(3, h4("Distance"),
  sliderInput("Distance",h3("Flight Distance Input"), min =0,max = 8809, value = c(0,8809))) 
), br()    )
  
   

# Define server logic ----
server <- function(input, output) {
  State <- map_data("state")
  G <- ggplot() + geom_polygon(
    data = State,
    aes(x = long, y = lat, group = group),
    fill = "grey96",
    color = "grey45"
  ) + coord_fixed(1.3, xlim = c(-122.5,-68), ylim = c(25, 50)) + theme_bw()
  output$DestFreq <- renderPlot({
    G+geom_point(data=FlightData, aes(x= FirstLong, y=FirstLat), point=.5)
  })
  

  
}

# Run the app ----
shinyApp(ui = ui, server = server)