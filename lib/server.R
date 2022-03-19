# server logic
server_ <- function(input, output, session) {

    # show data type-specific inputs
    output$dataTypeInputs <- renderUI({
        req(input$dataType)
        dt <- config$data_types[[input$dataType]]
        req(dt)
        tagList(
            textInput(
                'objectFolders',
                dt$label
            ),
            checkboxInput('overwrite', "Overwrite Existing Files"),
            bsButton('pushToS3', 'Push Data Files to S3', style = "primary"),
            tags$div(
                style="padding-top: 10px;",
                withSpinner(verbatimTextOutput('pushResults'))
            )
        )
    })

    # execute a data push
    output$pushResults <- renderText({
        req(input$pushToS3)
        isolate({  
            pushToS3(input$dataType, input$objectFolders, input$overwrite)          
        })
    })
}
