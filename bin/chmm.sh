#!/bin/sh

USER=$(whoami)
TIME=$(date)
BASEDIR=$HOME/chmm
LOG=$HOME/chmm/logs/log
 
section_1(){
   
    # Section 1 - Software Updates and Verification
 
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

    # Check to verify App Updates
    if [ $(defaults read /Library/Preferences/com.apple.commerce AutoUpdate) -eq 1 ]; then
        echo "[ PASS ] App Update Installs" >> $LOG
    else
        defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
        
        if [ $(defaults read /Library/Preferences/com.apple.commerce AutoUpdate) -eq 1 ]; then
            echo "[ PASS - FIXED ] App Update Installs" >> $LOG
        else
            echo "[ FAILED ] App Update Installs" >> $LOG
        fi
    fi

    echo $TIME >> $LOG
    echo "SECTION 1 COMPLETE" >> $LOG
}

section_2(){
    
    # Section 2 - General System Security Practices
    
    echo $TIME >> $LOG
    echo "BEGINING SECTION 2 - GENERAL SYSTEM SECURITY" >> $LOG

    # Bluetooth is Disabled unless a Device is Connected 
    if [ "$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState)" -eq "0" ]; then
        echo "[PASSED] 2.1.1 Bluetooth is disabled" >> $LOG

    else
        if [ "$(defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState)" -eq "1" ]; then
            result=$(system_profiler SPBluetoothDataType | grep "Bluetooth:" -A 20 | grep Connectable)
            if [ "$result" == "          Connectable: Yes" ]; then
                echo "[PASSED] 2.1.1 Bluetooth is Disabled unless Paired" >> $LOG
            else
                echo "[FAILED] 2.1.1 Bluetooth is not Disabled and no Device Connected." >> $LOG
            fi
        else
            echo "General Failure...." >> $LOG
        fi
    fi
    
    # Show bluetooth status in menubar

    if defaults read com.apple.systemuiserver menuExtras | grep -q Bluetooth.menu ; then
        echo "[PASSED] 2.1.3 Show bluetooth status in menubar" >> $LOG
    else
       echo "[FAILED] 2.1.3 Show bluetooth status in menubar." >> $LOG
        defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

        if defaults read com.apple.systemuiserver menuExtras | grep -q Bluetooth.menu ; then
            echo "[FIXED] 2.1.3 Show bluetooth status in menubar" >> $LOG
        else
            echo "[FAILURE] 2.1.3 Show bluetooth status in menubar" >> $LOG
        fi
    fi

}

main(){
    
    echo $TIME >> $HOME/chmm/logs/log
    echo "BEGINING CANTHACKMYMAC" >> $HOME/chmm/logs/log
    section_1
    section_2

}

main
