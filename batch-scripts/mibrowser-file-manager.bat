ECHO OFF
REM utility to transfer data files from a cluster server to the MIBrowser AWS S3 bucket
REM this script launches an R Shiny app on the server that is used in a local web browser

REM local (optional, uses password login if SSH_KEY_FILE omitted)
SET SSH_KEY_FILE=-i "C:/Users/wilso/Dropbox (University of Michigan)/WILSONTE_DROPBOX/Florida/bitvise/y.mbni.org.pem"

REM server specifications
SET USER=wilsonte
SET SERVER=wilsonte-lab.mbni.org
SET PORT=3850
SET TOOL_DIR=/garage/wilsonte_lab/bin
SET R_DIR=/garage/wilsonte_lab/bin/R/R-4.1.3/bin
SET R_LOAD_COMMAND=NA

REM use ssh with port tunnel to run the app on the server
ssh %SSH_KEY_FILE% -o "StrictHostKeyChecking no" -L %PORT%:127.0.0.1:%PORT% %USER%@%SERVER% ^
bash %TOOL_DIR%/mibrowser-file-manager/remote.sh %PORT% %R_DIR% %R_LOAD_COMMAND%

PAUSE
