# utility to transfer data files from a cluster server to the MIBrowser AWS S3 bucket
# this script launches an R Shiny app on the server that is accessed in a local web browser

#------------------------------------------------------------------------------------
# user login specifications - EDIT THIS SECTION
#   USER is required, replace with your uniqname, or user name on the server
#   SSH_KEY_FILE is optional, uses password login if omitted or commented out with '#'
#------------------------------------------------------------------------------------
USER=uniqnname
# SSH_KEY_FILE="-i /path/to/key-file"
#------------------------------------------------------------------------------------

# server specifications - edit this section if you need to, most people can leave as is
SERVER=wilsonte-lab.mbni.org
PORT=3850
TOOL_DIR=/garage/wilsonte_lab/bin
R_DIR=/garage/wilsonte_lab/bin/R/R-4.1.3/bin
R_LOAD_COMMAND=NA

# use ssh with port tunnel to run the app on the server - do not edit this section
ssh $SSH_KEY_FILE -o "StrictHostKeyChecking no" -L $PORT:127.0.0.1:$PORT $USER@$SERVER \
bash $TOOL_DIR/mibrowser-file-manager/remote.sh $PORT $R_DIR $R_LOAD_COMMAND
