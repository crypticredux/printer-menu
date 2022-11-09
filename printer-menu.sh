#!/bin/bash
# shebang tag, followed by instantiated variables.
# I wrote this in 2 days. I apologize, please bear with me. Runs only for a 
# specific printer until variables are set up.
# CUPS server will be added in a separate branch.
PRINTERSLIST=$(lpstat -d)
DRIVERSLIST=$(lpinfo --make-and-model "HP Officejet Pro 8610" -m)
__menu="
        1 - driver update
        2 - disable/enable printing
        3 - print a test page
        4 - restart printer daemon
        5 - exit
"


# echoes the default printer, which is the only printer on my server.
available_printers() {
        printf "Welcome user! Available printers:\n "
        echo "${PRINTERSLIST}"
        printf "\nThe default printer is available."
}


# offers available drivers.
drivers_updater() {
        printf "\nThere are optional drivers available to install. "

        # takes user input with a y or n, does not require the user to press enter.
        read -n1 -p "\nWant to update your drivers? (y/N): " userdriverupdate

        # when updating, asks for a 0, 1, 2, 3, or hpcups to choose a driver from the list. if yes, it will run the driver command. if no, will pass
        if [[ "$userdriverupdate" == "Y" || "$userdriverupdate" == "y" ]]
        then
                echo "${DRIVERSLIST}"
                read -n1 -p "\nWhich driver? (will require sudo: only options are 0, 1, 2, or 3 for hplip options, or 4 for hpcups.)" selecteddriver
                if [[ $selecteddriver -eq 0 ]]
                then
                        sudo lpadmin -p HP_Officejet_Pro_8610_0E5470_2_ -m "hplip:0/ppd/hplip/HP/hp-officejet_pro_8610.ppd HP Officejet Pro 8610, hpcups 3.20.3" && printf "\nInstalled hplip:0 driver."
                elif [[ $selecteddriver -eq 1 ]]
                then
                        sudo lpadmin -p HP_Officejet_Pro_8610_0E5470_2_ -m "hplip:1/ppd/hplip/HP/hp-officejet_pro_8610.ppd HP Officejet Pro 8610, hpcups 3.20.3" && printf "\nInstalled hplip:1 driver."
                elif [[ $selecteddriver -eq 2 ]]
                then
                        sudo lpadmin -p HP_Officejet_Pro_8610_0E5470_2_ -m "hplip:2/ppd/hplip/HP/hp-officejet_pro_8610.ppd HP Officejet Pro 8610, hpcups 3.20.3" && printf "\nInstalled hplip:2 driver."
                elif [[ $selecteddriver -eq 3 ]]
                then
                        sudo lpadmin -p HP_Officejet_Pro_8610_0E5470_2_ -m "hplip:3/ppd/hplip/HP/hp-officejet_pro_8610.ppd HP Officejet Pro 8610, hpcups 3.20.3" && printf "\nInstalled hplip:3 driver."
                elif [[ $selecteddriver -eq 4 ]]
                then
                        sudo lpadmin -p HP_Officejet_Pro_8610_0E5470_2_ -m "drv:///hpcups.drv/hp-officejet_pro_8610.ppd HP Officejet Pro 8610, hpcups 3.20.3" && printf "\nInstalled hpcups driver."
                else
                        printf "\nError. Not an available driver."
                fi
        else
                :
        fi
}



#if-else to run disable/enable commands
printing_switch() {
        read -n1 -p "\nHold further printing jobs? (will require sudo) (y/N): " jobshold
        if [[ "$jobshold" == "Y" || "$jobshold" == "y" ]]
        then
                sudo cupsdisable -r "\nPrinter disabled." HP_Officejet_Pro_8610_0E5470_2_
        else
                sudo cupsenable -r "\nPrinter enabled." HP_Officejet_Pro_8610_0E5470_2_
        fi
}


#if-else to print a test page that already exists
test_print() {
        read -n1 -p "\nPrint test page? (y/N): " testprintrun
        if [[ "$testprintrun" == "Y" || "$testprintrun" == "y" ]]
        then
                lpr print_test.txt && printf "\nTest printed".
        else
                :
        fi
}

#if-else to restart CUPS, may resolve errors.
daemon_restart() {
        read -n1 -p "\nRestart the CUPS service? (y/N): " cupsrestart
        if [[ "$cupsrestart" == "Y" || "$cupsrestart" == "y" ]]
        then
                /etc/init.d/cups restart && printf "\nRestarted CUPS."
        else
                :
        fi
}


#if-else to exit the script.
print_exit_action() {
        printf "\nGoodbye!"
        sleep 2.5s
        exit
}

#main menu
main_printer_menu() {
        available_printers
        printf "\nEnter a number to choose an option."
        read -n1 -p "$__menu" usermenuentry
        if [[ $usermenuentry -eq 1 ]]
        then
                drivers_updater
        elif [[ $usermenuentry -eq 2 ]]
        then
                printing_switch
        elif [[ $usermenuentry -eq 3 ]]
        then
                test_print
        elif [[ $usermenuentry -eq 4 ]]
        then
                daemon_restart
        elif [[ $usermenuentry -eq 5 ]]
        then
                print_exit_action
        else
                main_printer_menu
        fi
}

#runs the main menu
echo ""
echo ""
echo ""
main_printer_menu

