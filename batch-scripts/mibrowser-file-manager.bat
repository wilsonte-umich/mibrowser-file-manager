ECHO OFF
REM utility to transfer data files from a cluster server to the MIBrowser AWS S3 bucket
REM this script launches an R Shiny app on the server that is accessed in a local web browser

REM ------------------------------------------------------------------------------------
REM user login specifications - EDIT THIS SECTION
REM   USER is required, replace with your uniqname, or user name on the server
REM   SSH_KEY_FILE is optional, uses password login if omitted or commented out with 'REM'
REM ------------------------------------------------------------------------------------
SET USER=uniqnname
REM SET SSH_KEY_FILE=-i "C:\Users\xxxxx\path\to\key-file"
REM ------------------------------------------------------------------------------------

REM server specifications - edit this section if you need to, most people can leave as is
SET SERVER=wilsonte-lab.mbni.org
SET PORT=3850
SET TOOL_DIR=/garage/wilsonte_lab/bin
SET R_DIR=/garage/wilsonte_lab/bin/R/R-4.1.3/bin
SET R_LOAD_COMMAND=NA

REM use ssh with port tunnel to run the app on the server - do not edit this section
ssh -t %SSH_KEY_FILE% -o "StrictHostKeyChecking no" -L %PORT%:127.0.0.1:%PORT% %USER%@%SERVER% ^
bash %TOOL_DIR%/mibrowser-file-manager/remote.sh %PORT% %R_DIR% %R_LOAD_COMMAND%

PAUSE
