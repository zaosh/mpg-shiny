library(shiny)

data(mtcars)
fit <- lm(mpg ~ wt + hp + am, data = mtcars)

shinyServer(function(input, output) {

  newcar <- reactive({
    data.frame(wt = input$wt, hp = input$hp, am = as.numeric(input$am))
  })

  prediction <- reactive({
    predict(fit, newcar(), interval = "prediction", level = 0.95)
  })

  output$pred <- renderText({
    paste(round(prediction()[1, "fit"], 1), "mpg")
  })

  output$range <- renderText({
    p <- prediction()
    paste0("95% prediction interval: ", round(p[1, "lwr"], 1), " to ", round(p[1, "upr"], 1), " mpg")
  })

  output$rating <- renderText({
    m <- prediction()[1, "fit"]
    r <- if (m >= 25) "Efficient" else if (m >= 18) "Average" else "Thirsty"
    paste("Fuel economy rating:", r)
  })

  output$plot <- renderPlot({
    plot(mtcars$wt, mtcars$mpg, pch = 19, col = "grey60",
         xlab = "Weight (1000 lbs)", ylab = "Miles per gallon",
         main = "mtcars data and your car")
    if (input$showfit) {
      grid <- data.frame(wt = seq(1.5, 5.5, length.out = 50), hp = input$hp, am = as.numeric(input$am))
      lines(grid$wt, predict(fit, grid), col = "blue", lwd = 2)
    }
    points(input$wt, prediction()[1, "fit"], col = "red", pch = 19, cex = 2.5)
    legend("topright", c("mtcars", "Your car"), col = c("grey60", "red"), pch = 19)
  })
})
