# UI elements 
ui_ <- function(request){
    fluidPage(
        tags$h3("MIBrowser File Manager"),
        tags$p("Use this tool to push data files to the MIBrowser AWS S3 bucket."),
        selectInput(
            'dataType',
            'Data Type',
            choices = names(config$data_types)
        ),
        uiOutput('dataTypeInputs')
    )
}
