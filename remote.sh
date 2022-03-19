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

# check for server currently running on PORT
PID_FILE=../mibrowser-file-manager-pid-$PORT.txt
PID=""
if [ -e $PID_FILE ]; then PID=`cat $PID_FILE`; fi
EXISTS=""
if [ "$PID" != "" ]; then EXISTS=`ps -p $PID | grep -v PID`; fi 

# launch Shiny if not already running
SEPARATOR="---------------------------------------------------------------------"
WAIT_SECONDS=5
if [ "$EXISTS" = "" ]; then
    echo $SEPARATOR 
    echo "Please wait $WAIT_SECONDS seconds for the web server to start"
    echo $SEPARATOR
    if [[ "$R_LOAD_COMMAND" != "" && "$R_LOAD_COMMAND" != "NA" ]]; then 
        $R_LOAD_COMMAND
        R_SCRIPT=Rscript
    else 
        R_SCRIPT=$R_DIR/Rscript
    fi
    exec $R_SCRIPT app.R $PORT &
    PID=$!
    echo "$PID" > $PID_FILE
    sleep $WAIT_SECONDS # give Shiny time to start up before showing further prompts   
fi

# report the PID to the user
echo $SEPARATOR
echo "Web server process running on remote port $PORT as PID $PID"

# report on browser usage within the command shell on user's local computer
echo $SEPARATOR
echo "Please point any web browser to:"
echo
echo "http://127.0.0.1:$PORT"
echo

# prompt for exit action, with or without killing of the R web server process
USER_ACTION=""
while [[ "$USER_ACTION" != "1" && "$USER_ACTION" != "2" ]]; do
    echo $SEPARATOR
    echo "To close the remote server connection:"
    echo
    echo "  1 - close the connection AND stop the web server (PREFERRED)"
    echo "  2 - close the connection, but leave the web server running (USE WITH CAUTION)"
    echo
    echo "Select an action (type '1' or '2' and hit Enter):"
    read USER_ACTION
done

# kill the web server process if requested
if [ "$USER_ACTION" = "1" ]; then
    echo
    echo "Killing remote MDI server process $PID running on port $PORT"
    kill -9 $PID
    echo "Done"
fi 

# send a final helpful message
# note: the ssh process on client will NOT exit when this script exits since it is port forwarding still
echo
echo "You may now safely close this command window."
