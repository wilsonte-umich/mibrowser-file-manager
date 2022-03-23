#!/bin/bash
#----------------------------------------------------------------
# run the MDI R server in 'remote' mode
# this script executes on the remote login server (not the user's local computer)
#----------------------------------------------------------------

# get input variables
export PORT=$1
export R_DIR=$2
export R_LOAD_COMMAND=$3
export TOOL_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $TOOL_DIR

# set helper variables
WAIT_SECONDS=5
SEPARATOR="---------------------------------------------------------------------"

# start the R Shiny web server if not already running on the server host
HTML=`curl 127.0.0.1:$PORT 2>/dev/null`
if [ "$HTML" = "" ]; then
    if [[ "$R_LOAD_COMMAND" != "" && "$R_LOAD_COMMAND" != "NA" ]]; then 
        $R_LOAD_COMMAND
        R_SCRIPT=Rscript
    else 
        R_SCRIPT=$R_DIR/Rscript
    fi   
    echo $SEPARATOR
    echo "starting R Shiny web server as:"
    echo "  nohup nice $R_SCRIPT app.R $PORT &"
    echo
    echo "please wait $WAIT_SECONDS seconds for server to start"
    echo
    nohup nice $R_SCRIPT app.R $PORT &
    sleep $WAIT_SECONDS
fi

# provide feedback to user
echo $SEPARATOR
echo "Please point any web browser to:"
echo
echo "http://127.0.0.1:$PORT"
echo

# wait for user to type "exit" to end their ssh call 
# or, they can simply close their command window
USER_ACTION=""
while [ "1" = "1" ]; do
    echo $SEPARATOR
    echo
    echo "To exit, close this command window (or type Ctrl-C repeatedly)"
    echo
    read USER_ACTION
done
