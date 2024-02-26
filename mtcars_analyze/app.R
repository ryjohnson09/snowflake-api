library(shiny)
library(bslib)
library(ggplot2)
library(httr)
library(jsonlite)

# Read in mtcars from API -------------
api_url <- "https://colorado.posit.co/rsc/snowflake_mtcars/data"

response <- GET(api_url)

# Check if the request was successful
if (http_type(response) == "application/json") {
  # Parse the JSON response
  mtcars_data <- httr::content(response, "text") |>
    fromJSON()
  
} else {
  cat("Request failed with status code:", http_status(response))
}

# User Interface -----------------------
ui <- page_sidebar(
  title = "mtcars dashboard",
  sidebar = sidebar(
    title = "Plot controls",
    varSelectInput(
      "x", "Select x axis variable",
      data = mtcars_data, 
      selected = "mpg"
    ),
    varSelectInput(
      "y", "Select y axis variable",
      data = mtcars_data,
      selected = "disp"
    )
  ),
  card(
    card_header("mtcars Plot"),
    plotOutput("p")
  )
)

# Server Function ------------------------
server <- function(input, output) {
  output$p <- renderPlot({
    ggplot(mtcars_data) +
      geom_point(aes(!!input$x, !!input$y)) +
      theme_bw(base_size = 20)
  })
}

shinyApp(ui, server)