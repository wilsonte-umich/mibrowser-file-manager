# run this script on the server to stop a persistent Shiny process
# must be executed by the same person who ran start-server.sh

# set the working directory
TOOL_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $TOOL_DIR

# source the config
source config.sh

# stop the server
PID=`lsof -i:$PORT | tail -n 1 | awk '{print $2}'`
if [ "$PID" != "" ]; then
    kill -9 $PID
    echo
    echo "killed Shiny server process $PID on port $PORT"
    echo
else
    echo
    echo "no Shiny server process is running on port $PORT"
    echo
fi 
