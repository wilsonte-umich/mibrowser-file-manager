# utility to transfer data files from a cluster server to the MIBrowser AWS S3 bucket
# this script launches an R Shiny app on the server that is used in a local web browser

# local (optional, uses password login if SSH_KEY_FILE omitted)
SSH_KEY_FILE="-i /path/to/key-file"

# server specifications
USER=wilsonte
SERVER=wilsonte-lab.mbni.org
PORT=3850
TOOL_DIR=/garage/wilsonte_lab/bin
R_DIR=/garage/wilsonte_lab/bin/R/R-4.1.3/bin
R_LOAD_COMMAND=NA

# use ssh with port tunnel to run the app on the server
ssh $SSH_KEY_FILE -o "StrictHostKeyChecking no" -L $PORT:127.0.0.1:$PORT $USER@$SERVER \
bash $TOOL_DIR/mibrowser-file-manager/remote.sh $PORT $R_DIR $R_LOAD_COMMAND
