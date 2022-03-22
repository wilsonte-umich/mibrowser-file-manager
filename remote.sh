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
INITIAL_PORT=$PORT
MAX_PORT=$((PORT + 100))

# get a PORT that we are able to use, i.e., that is not already busy
function set_shiny_pid { # PID of the process running at $PORT, if any 
    PID=`lsof -i :$PORT | tail -n1 | awk '{print $2}'`   
}
set_shiny_pid
while [[ "$PID" != "" && $PORT -lt $MAX_PORT ]]; do
    PORT=$((PORT + 1))
    set_shiny_pid
done

# fail if no usable port is available
if [ "$PID" != "" ]; then
    echo $SEPARATOR
    echo "No ports are available between $PORT and $MAX_PORT."
    echo "Cannot start the server."
    echo $SEPARATOR
    exit 1
fi

# report if we had to change ports from the original request
if [ "$PORT" != "$INITIAL_PORT" ]; then
    echo $SEPARATOR
    echo "NOTE: port $INITIAL_PORT was already in use."
    echo "Switched to port $PORT."
    echo "Be sure to use the correct port in your web browser."
fi

# provide feedback to user
echo $SEPARATOR
echo "Please wait $WAIT_SECONDS seconds for the web server to start,"
echo "then point any web browser to:"
echo
echo "http://127.0.0.1:$PORT"
echo
echo $SEPARATOR

# finally, start the R Shiny process, which blocks until a SIGINT or SIGHUP occurs
# NB: it is important that ssh -t is used so that SIGHUP is generated when SSH connection ends
if [[ "$R_LOAD_COMMAND" != "" && "$R_LOAD_COMMAND" != "NA" ]]; then 
    $R_LOAD_COMMAND
    R_SCRIPT=Rscript
else 
    R_SCRIPT=$R_DIR/Rscript
fi   
echo "$R_SCRIPT app.R $PORT"
exec $R_SCRIPT app.R $PORT
