#!/bin/sh

USER=$(whoami)
TIME=$(date)
BASEDIR=$HOME/chmm
LOG=$HOME/chmm/logs/log
 
section_1(){
    
    echo $TIME >> $LOG
    echo "BEGINING SECTION 1 - SOFTWARE VERIFICATION" >> $LOG

    # Check to verify Auto-Update are ON
    if [ $(defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled) -eq 1 ]; then
        echo " [ PASS ] Automatic Software Updates are Enabled." >> $LOG
    else
        # turn on auto-updates by setting value to 1
        defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -int 1
        
        if [ $(defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled) -eq 1 ]; then
            echo "[ PASS - FIXED ] Automatic Software Updates are Enabled." >> $LOG
        else
            echo "[ FAILED ] Automatic Softare Updates are Disabled." >> $LOG
        fi
    fi

    ####
}

main(){
    
    echo $TIME >> $HOME/chmm/logs/log
    echo "BEGINING CANTHACKMYMAC" >> $HOME/chmm/logs/log
    section_1

}

main
