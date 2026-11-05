library(shiny)

shinyUI(fluidPage(
  titlePanel("Car Fuel Economy Predictor"),
  sidebarLayout(
    sidebarPanel(
      h4("Describe your car"),
      sliderInput("wt", "Weight (1000 lbs):", min = 1.5, max = 5.5, value = 3, step = 0.1),
      sliderInput("hp", "Horsepower:", min = 50, max = 340, value = 120, step = 5),
      radioButtons("am", "Transmission:", choices = c("Automatic" = 0, "Manual" = 1)),
      checkboxInput("showfit", "Show regression line on plot", value = TRUE),
      helpText("Move the sliders or change the options. Results update instantly.")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction",
          h3("Predicted miles per gallon"),
          h2(textOutput("pred")),
          textOutput("range"),
          textOutput("rating"),
          plotOutput("plot")
        ),
        tabPanel("How to use this app",
          h3("Quick start"),
          tags$ol(
            tags$li("Use the ", strong("Weight"), " and ", strong("Horsepower"), " sliders to describe a car."),
            tags$li("Choose ", strong("Automatic"), " or ", strong("Manual"), " transmission."),
            tags$li("Open the ", strong("Prediction"), " tab: the predicted mpg and a 95% prediction interval appear immediately."),
            tags$li("The plot shows real cars from the built-in ", code("mtcars"), " dataset (grey), the fitted line (blue) and your car (red).")
          ),
          h3("How it works"),
          p("The app fits a linear model, ", code("mpg ~ wt + hp + am"), ", to the 32 cars in ", code("mtcars"),
            " and uses it to predict mpg for the car you describe. No installation or R knowledge needed."),
          p("Tip: heavier, more powerful cars use more fuel, so the prediction drops as you raise weight or horsepower.")
        )
      )
    )
  )
))
