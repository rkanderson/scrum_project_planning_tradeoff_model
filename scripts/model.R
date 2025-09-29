
# This is a simple model that simulates the time consumption of a project
# with a planning component. 
run_model <- function(sim_periods, r, plan_scope, c, k, B, p, stochastic = FALSE, sd_r = 0.5, sd_c = 5, sd_k = 10, sd_B = 10, sd_p = 0.5) {
  
  # Set seed for reproducibility
  set.seed(123)
  
  # Initialize the vectors
  working_time <- vector("numeric", length = sim_periods)
  planning_time <- vector("numeric", length = sim_periods)
  time_consumption <- vector("numeric", length = sim_periods)
  plan_usefulness <- vector("numeric", length = sim_periods)
  
  # Get error terms if we are using a stochastic model
  # We will want an error term for the r at each period
  # We'll also need ones for getting D and L at any given time.
  if (stochastic) {
    error_r <- rnorm(sim_periods, mean = 0, sd = sd_r)
    error_c <- rnorm(sim_periods, mean = 0, sd = sd_c)
    error_k <- rnorm(sim_periods, mean = 0, sd = sd_k)
    error_B <- rnorm(sim_periods, mean = 0, sd = sd_B)
    error_p <- rnorm(sim_periods, mean = 0, sd = sd_p)
  } else {
    error_r <- rep(0, sim_periods)
    error_c <- rep(0, sim_periods)
    error_k <- rep(0, sim_periods)
    error_B <- rep(0, sim_periods)
    error_p <- rep(0, sim_periods)
  }
  
  # Initialize the first period
  # we assume that a plan is always developed in period 1
  planning_time[1] <- (max(0, c + error_c[1])) * plan_scope + (max(0, k + error_k[1]))
  plan_usefulness[1] <- 1
  
  # We also complete the required workload in period 1 with a 100% useful plan
  working_time[1] <- (max(0, B + error_B[1])) * (1 - max(0, min(1, p + error_p[1])) * plan_usefulness[1])
  
  # Add working and planning time to get the total time consumption
  time_consumption[1] <- working_time[1] + planning_time[1]
  
  # Start a counter so we know when to make the next plan
  time_since_last_plan <- 0
  
  # browser()
  
  # Begin the loop
  for (t in 2:sim_periods) {
    
    
    # Update the plan usefulness
    plan_usefulness[t] <- plan_usefulness[t-1] * (max(0, min(1, r + error_r[t])))
    
    # Update time counter
    time_since_last_plan <- time_since_last_plan + 1
    
    # Develop a new plan if the scope is reached
    # (And don't make a plan if you're on the final period)
    if (time_since_last_plan == plan_scope && t != sim_periods) {
      planning_time[t] <- (max(0, c + error_c[t])) * plan_scope + (max(0, k + error_k[t]))
      plan_usefulness[t] <- 1
      time_since_last_plan <- 0
    } else {
      planning_time[t] <- 0
    }
    
    # Update the time consumption with the current period's time demand
    working_time[t] <- (max(0, B + error_B[t])) * (1 - (max(0, min(1, p+error_p[t]))) * plan_usefulness[t])
    
    # Add working time and planning time to get total time consumption
    time_consumption[t] <- planning_time[t] + working_time[t]
    
    # browser()
  }
  
  # Return the results
  return(data.frame(period = 1:sim_periods, time_consumption = time_consumption, plan_usefulness = plan_usefulness, working_time = working_time, planning_time = planning_time))
  
}


# model_results_stochastic %>% 
#   ggplot(aes(x = period, y = time_consumption)) +
#   geom_line() +
#   geom_vline(xintercept = seq(8, SIM_PERIODS, 8)+1, linetype = "dashed") +
#   labs(title = "Time Consumption Over Weeks (Stochastic)",
#        x = "Week",
#        y = "Person Hours") +
#   theme_minimal()



plot_model_run <- function(model_run, sigma) {
  return(
    model_run %>% 
    ggplot(aes(x = period, y = time_consumption)) +
    geom_line() +
    geom_vline(xintercept = seq(0, nrow(model_run), sigma)+1, linetype = "dashed") +
    labs(x = "Week",
         y = "Person Hours") +
    theme_minimal()
  )
    # geom_ribbon(aes(ymin = time_consumption - sigma, ymax = time_consumption + sigma), alpha = 0.3)
}

get_model_summary <- function(model_run) {
  return(
    list(
      "Total Working Time" = sum(model_run$working_time),
      "Total Planning Time" = sum(model_run$planning_time),
      "Total Time Consumption" = sum(model_run$time_consumption)
    )
  )
}


run_stochastic_repetitions <- function(n_reps, SIM_PERIODS, PLAN_DECAY_RATE, PLAN_SCOPE, C, K, B, P, SD_R, SD_C, SD_K, SD_B, SD_P) {
  results <- tibble()
  for (i in 1:n_reps) {
    model_results <- run_model(SIM_PERIODS, PLAN_DECAY_RATE, PLAN_SCOPE, C, K, B, P, 
                               stochastic = TRUE, sd_r = SD_R, sd_c = SD_C, sd_k = SD_K, sd_B = SD_B, sd_p = SD_P) %>% mutate(run = i)
    results <- bind_rows(results, model_results)
  }
  
  results_summary <- results %>% 
    group_by(run) %>% 
    summarize(total_time_consumption = sum(time_consumption), 
              total_working_time = sum(working_time), 
              total_planning_time = sum(planning_time)) %>% 
    summarize(mean_total_time_consumption = mean(total_time_consumption),
              mean_total_working_time = mean(total_working_time), 
              mean_total_planning_time = mean(total_planning_time))
  
  return(list(results = results, results_summary = results_summary))
}
