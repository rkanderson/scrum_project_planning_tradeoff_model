# Clear env
rm(list = ls())

# Load required libraries
library(shiny)
# library(here)
library(nloptr)
library(tidyverse)
library(shinydashboard)


# Source the necessary scripts
# source(here("Final Project", "scripts", "model.R"))
source("model.R")

# Default parameter values
SIM_PERIODS <- 52 # if we use weeks as a period, this will let us simulate a 1 year long project
PLAN_DECAY_RATE <- 0.9 # with 0.9, in 6 weeks, you get about 50% usefulness
PLAN_SCOPE <- 4 # 4 week plan
C <- 1 # one person-hour per week of plan drafting
K <- 1 # one person-hour baseline of overhead for plan drafting
B <- 40 # Baseline time demand for a week's worth of work on the project is 40 person hours
P <- 0.2 # You can reduce the time demand by 20% at most by having a perfectly applicable plan.

# Define UI
ui <- fluidPage(
  titlePanel("Project Time Demand Simulation Model"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Model Parameters"),
      
      sliderInput("sim_periods", "Simulation Periods (weeks)", min = 1, max = 100, value = 52),
      sliderInput("plan_decay_rate", "Plan Decay Rate (r)", min = 0, max = 1, value = 0.9),
      sliderInput("plan_scope", "Plan Scope (sigma)", min = 1, max = 52, value = 4),
      sliderInput("c", "Plan Drafting Coefficient (c)", min = 0, max = 20, value = 1),
      sliderInput("k", "Plan Drafting Overhead (k)", min = 0, max = 20, value = 1),
      sliderInput("B", "Baseline Time Demand (B)", min = 0, max = 100, value = 40),
      sliderInput("p", "Time Demand Reducibility (p)", min = 0, max = 1, value = 0.2),
      checkboxInput("stochastic", "Stochastic Model", value = TRUE),
      # Add inputs for standard deviations:
      sliderInput("sd_r", "SD of r", min = 0, max = 1, value = 0.1),
      sliderInput("sd_c", "SD of c", min = 0, max = 20, value = 0.1),
      sliderInput("sd_k", "SD of k", min = 0, max = 20, value = 1),
      sliderInput("sd_B", "SD of B", min = 0, max = 100, value = 1),
      sliderInput("sd_p", "SD of p", min = 0, max = 1, value = 0.1)
    ),
    
    mainPanel(
      fluidRow(
        # Display the three numbers in value boxes
        valueBoxOutput("working_time"),
        valueBoxOutput("planning_time"),
        valueBoxOutput("total_time_consumption")
      ),
      plotOutput("time_consumption_plot"),
    )
  )
)

# Define server
server <- function(input, output) {
  # Reactive optimization result based on inputs
  model_run <- reactive({
    
    # TODO run the model with the input parameters, including the sd_ terms
    # run_model(input$sim_periods, input$plan_decay_rate, input$plan_scope, 
    #           input$c, input$k, input$B, input$p, 
    #           stochastic = input$stochastic, )
    run_model(input$sim_periods, input$plan_decay_rate, input$plan_scope, 
              input$c, input$k, input$B, input$p, 
              stochastic = input$stochastic, 
              sd_r = input$sd_r, sd_c = input$sd_c, sd_k = input$sd_k, sd_B = input$sd_B, sd_p = input$sd_p)
    
  })
  
  
  # Render plots
  output$time_consumption_plot <- renderPlot({
    # TODO display plot with visualization function and by calling model_run() reactive
    plot_model_run(model_run(), input$plan_scope)
    # print("HELLO")
  })
  
  # Render value boxes
  output$working_time <- renderValueBox({
    valueBox(
      value = sum(model_run()$working_time) %>% round(),
      subtitle = "Total Working Time (Person Hrs)",
      icon = icon("hammer"),
      color = "orange"
    )
  })
  
  output$planning_time <- renderValueBox({
    valueBox(
      value = sum(model_run()$planning_time) %>% round(),
      subtitle = "Total Planning Time (Person Hrs)",
      icon = icon("pencil"),
      color = "blue"
    )
  })
  
  output$total_time_consumption <- renderValueBox({
    valueBox(
      value = sum(model_run()$time_consumption) %>% round(),
      subtitle = "Total Time Consumption (Person Hrs)",
      icon = icon("clock"),
      color = "green"
    )
  })
  # output$value1 <- renderValueBox({
  #   valueBox(
  #     value = 20,
  #     subtitle = "Maximum Stock",
  #     icon = icon("fish"),
  #     color = "blue"
  #   )
  # })
  # 
  # output$value2 <- renderValueBox({
  #   valueBox(
  #     value = 10,
  #     subtitle = "Total Harvest",
  #     icon = icon("tractor"),
  #     color = "green"
  #   )
  # })
  # 
  # output$value3 <- renderValueBox({
  #   valueBox(
  #     value = 5,
  #     subtitle = "Optimal Effort",
  #     icon = icon("chart-line"),
  #     color = "purple"
  #   )
  # })
  
}

# Run the application
shinyApp(ui = ui, server = server)
