# Load the deployment package
library(rsconnect)

# Path to your Shiny app folder
app_dir <- "shinyapp"

# Deploy the app to shinyapps.io
rsconnect::deployApp(
  appDir = app_dir,
  appName = "scrum_project_planning_tradeoff_model",
  forceUpdate = TRUE   # overwrite the app if it already exists
)
