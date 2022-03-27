# run this script on the server to launch a persistent Shiny process
# used by an admin to create a shared web server

# set the working directory
export TOOL_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $TOOL_DIR

# source the config
source config.sh

# check to see if server is already running
HTML=`curl 127.0.0.1:$PORT 2>/dev/null`
if [ "$HTML" != "" ]; then
    echo
    echo "file upload server is already running on port $PORT"
    echo
    
# start the server
else 
    if [[ "$R_LOAD_COMMAND" != "" && "$R_LOAD_COMMAND" != "NA" ]]; then 
        $R_LOAD_COMMAND
        R_SCRIPT=Rscript
    else 
        R_SCRIPT=$R_DIR/Rscript
    fi   
    echo "starting R Shiny web server as:"
    echo "  nohup nice $R_SCRIPT app.R $PORT &"
    nohup nice $R_SCRIPT app.R $PORT &    
    echo
    echo "server is now running at port $PORT"
    echo
fi
