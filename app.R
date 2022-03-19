# Utility to transfer data files from a cluster server to the MIBrowser AWS S3 bucket

# load dependencies
library(shiny)
library(shinycssloaders)
library(shinyBS)
library(yaml)
# library(jsonlite)

# load configuration
config  <- read_yaml('config.yml')
scripts <- list.files('lib', full.names = TRUE)

# proxy the ui and server functions to support development without server restart
ui <- function(request){ 
    sapply(scripts, source)
    ui_(request) 
}
server <- function(input, output, session){ 
    sapply(scripts, source)
    server_(input, output, session) 
}

# run the server
args = commandArgs(trailingOnly = TRUE)
shinyApp(
    ui = ui, 
    server = server,
    options = list(
        host = '0.0.0.0',
        port = as.integer(args[1])
    )
)
