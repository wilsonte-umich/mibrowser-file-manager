# makes calls to S3 via the system AWS CLI
# note: the R aws.s3 package sometimes fails installation due to missing system libraries...

# set AWS credentials for IAM User
credentialsFile <- file.path(Sys.getenv("TOOL_DIR"), "credentials")
cliEnvVars <- paste("AWS_SHARED_CREDENTIALS_FILE", credentialsFile, sep = "=")

# general function for interacting with the bucket
awsS3 <- function(args){
    args <- c("s3", args)
    # message(paste(c("       ", config$aws_cli, args), collapse = " "))
    result <- system2(
        config$aws_cli, 
        args = args,
        stdout = TRUE,
        env = cliEnvVars
    )
    status <- attributes(result)$status
    if(!is.null(status) && status != 0) {
        list(
            success = FALSE,
            result = "AWS CLI threw an error; check the R command window or nohop.out for details"
        )
    } else {
        list(
            success = TRUE,
            result = result
        )
    }
}

# list the contents of the bucket
# this is challenging to use well since we have so many samples!
# listS3 <- function(prefix = NULL){
#     args <- c("s3api", "list-objects", "--bucket", config$s3_bucket, "--page-size", 1000, "--delimiter ", "/")
#     if(!is.null(prefix)) args <- c(args, "--prefix", prefix)
#     fromJSON(system2(
#         "aws", 
#         args = args,
#         stdout = TRUE,
#         env = cliEnvVars
#     ))
# }

# transfer data from server to S3 with extensive validation
pushToS3_ <- function(exclude, include, objects, fileCounts, dryrun = FALSE){
    dryrunOption <- if(dryrun) "--dryrun" else c()
    lapply(seq_along(objects), function(i){
        x <- objects[[i]]
        message(paste("   ", x$objectFolder))
        if(fileCounts[i] == 0){
            awsS3(c("cp", exclude, include, dryrunOption, "--recursive", x$serverFolder, x$s3URI))
        } else {
            list(
                success = TRUE,
                result = "already in bucket"
            )
        }
    })
}
pushToS3 <- function(dataType, objectFolders, overwrite){

    # check the inputs
    req(dataType)
    req(objectFolders)
    dataType      <- trimws(dataType)    
    objectFolders <- gsub(",", " ", objectFolders)
    objectFolders <- gsub(";", " ", objectFolders)
    objectFolders <- trimws(objectFolders)
    req(dataType)
    req(objectFolders)
    dt <- config$data_types[[dataType]]
    req(dt)

    # set the file inclusions/exclusions
    exclude <- as.vector(if(!is.null(dt$exclude)){
        sapply(dt$exclude, function(ext) c("--exclude ", paste0("'*.", ext, "'")))
    } else { # if including, must forcefully exclude everything first, or all transfers anyway!
        if(is.null(dt$include)) character() else c("--exclude ", "'*'")
    })
    include <- as.vector(if(!is.null(dt$include)){
        sapply(dt$include, function(ext) c("--include ", paste0("'*.", ext, "'")))
    } else {
        character()
    })

    # check the existence of all request data objects
    message("checking for source existence")
    objectFolders <- strsplit(objectFolders, '\\s+')[[1]]
    objects <- lapply(objectFolders, function(objectFolder){
        message(paste("   ", objectFolder))
        prefix <- file.path(dt$prefix, objectFolder)
        serverFolder <- file.path(dt$server_folder, prefix)
        s3URI <- file.path("s3:/", config$s3_bucket, prefix)
        exists <- dir.exists(serverFolder)
        if(!exists) stop(safeError(paste("unknown data source:", objectFolder)))
        list(
            objectFolder = objectFolder,
            serverFolder = serverFolder,
            s3URI = s3URI
        )
    })

    # unless overwriting, skip files that already exist
    fileCounts <- if(overwrite){
        rep(0, length(objects))
    } else {
        message("checking for destination existence")
        sapply(objects, function(x){
            message(paste("   ", x$objectFolder))
            ls <- awsS3(c("ls", x$s3URI))
            if(ls$success) ls$result else 0
        })
    }

    # check the transfers with AWS CLI one at a time
    message("doing dry run(s)")
    dryRun <- pushToS3_(exclude, include, objects, fileCounts, TRUE)
    ready  <- sapply(dryRun, function(x) x$success)
    dryRun <- sapply(dryRun, function(x) x$result)
    if(!all(ready)) stop(paste(paste(objectFolders, dryRun, sep = " : "), collapse = "\n\n"))

    # do the transfer with AWS CLI one at a time
    message("executing the transfer(s)")
    results <- pushToS3_(exclude, include, objects, fileCounts)
    success <- sapply(results, function(x) x$success)
    results <- sapply(results, function(x) x$result)
    if(!all(success)) stop(paste(paste(objectFolders, results, sep = " : "), collapse = "\n\n"))
    message("done")    
    paste(paste(objectFolders, results, sep = " : "), collapse = "\n\n")
}
