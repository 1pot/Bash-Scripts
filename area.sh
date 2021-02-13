#!/bin/bash
function banner(){
# banner using https://www.askapache.com/online-tools/figlet-ascii/
echo
echo "######"
echo "#     # ######  ####  #####   ##   #    #  ####  #      ######"
echo "#     # #      #    #   #    #  #  ##   # #    # #      #"
echo "######  #####  #        #   #    # # #  # #      #      #####"
echo "#   #   #      #        #   ###### #  # # #  ### #      #"
echo "#    #  #      #    #   #   #    # #   ## #    # #      #"
echo "#     # ######  ####    #   #    # #    #  ####  ###### ######"
echo
}

function cmSquare(){
# make a multiplication with the user's input
# print square in centimeters
cmSquare=$(echo "scale=1;${witdh}*${height}" | bc)
echo "Area: "${cmSquare} " (sqcm) "
}

function inSquare(){
# make a 2.54 division with the result of cmSquare
# print square in inches
inSquare=$(echo "scale=1;${cmSquare}/2.54/2.54" | bc)
echo "Area: "${inSquare} " (sqin) "
}

userInput='y'
while [[ $userInput == [yY] ]]; do
clear
echo -e "\e[32mThis is a program which displays the area of a rectangle both in cm and in inches"
echo -e "\e[31m################################################################"
echo ""
echo -e "\e[32m 1. Calculating the area of a rectangle\e[33m[Area]";
echo -e "\e[32m 2. Objectives\e[33m[Objectives]";
echo ""
echo -e "\e[31m################################################################"
read -p " Available Choices [1-2] type \"exit\" to exit :" cases;
echo -e "\e[31m################################################################"
echo -e "\e[39m"
case $cases in
1)
banner
while :; do
    read -p "Enter Witdh  in cm: " witdh
    read -p "Enter Height in cm: " height
if [[ $witdh =~ ^[+-]?([0-9]+\.[0-9]+)$ ]]; then break;
            else
                if [[ $height =~ ^[+-]?([0-9]+\.[0-9]+)$ ]]; then break;
            else
                if [[ $witdh =~ ^[0-9]+$ ]]; then break;
            else
                if [[ $height =~ ^[0-9]+$ ]]; then break;
            fi
        fi
    fi
fi
done
cmSquare
inSquare
;;
2)
echo "By typing 1, you will be asked for width first and then height, both numbers has to be in cm"
echo "Note; only numbers are accepted"

;;
exit)
exit 0
;;
*)
echo "Your choice is not available"
exit 1
;;
esac
echo -n "Would you like to go back to the main menu(Y/N): ";
read userInput;
done