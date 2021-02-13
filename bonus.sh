#!/usr/bin/env bash
banner(){
# banner using https://www.askapache.com/online-tools/figlet-ascii/
echo -e "\e[33m"
echo "######"                          
echo "#     #  ####  #    # #    #  ####"  
echo "#     # #    # ##   # #    # #"      
echo "######  #    # # #  # #    #  ####"  
echo "#     # #    # #  # # #    #      #" 
echo "#     # #    # #   ## #    # #    #" 
echo "######   ####  #    #  ####   ####"  
echo -e "\e[32m"
}
Objectives(){
echo
printf "\e[32mBelow you can read how the 4 options above work\n"
echo   "#############################################################################################################\m"
printf "\e[33mChoice 1: \e[37m[Just type 1) And the results should be displayed on how many sale person is added]\n"
printf "\e[33mChoice 2: \e[37m[write a name, a sale and choose wether you like to save into text file or not to]\n"
printf "\e[33mChoice 3: \e[37m[Choose between a/A for Alphabetticaly or s/S for ordering in sale from low to higher]\n"
printf "\e[33mChoice 4: \e[37m[This choise is the choice you are in]\n"
printf "\e[31mAnother choice is typing exit, which will quit the script\n"
printf "\e[32m######################################################################################################\n"
}

declare -A salesPeople

sales_file=sales.txt

#reads file sales.txt
if [[ -f $sales_file ]]; then
  while IFS='=' read name sales; do
    salesPeople[$name]=$sales
  done <"$sales_file"
fi

displaySalesPeople() {
  for key in "${!salesPeople[@]}"; do
    echo "$key=${salesPeople[$key]}"
  done
}

# using standard sorting tool here
sortByAlphabet_unix() {
  sort
}

# bubble sort in Bash
sortByAlphabet() {
  local values=($(cat))
  local n=${#values[@]}
  local swapped i tmp

  while :; do
    swapped=
    for ((i = 1; i < n; i++)); do
      if [[ ${values[i - 1]} > ${values[i]} ]]; then
        tmp=${values[i - 1]}
        values[i - 1]=${values[i]}
        values[i]=$tmp
        swapped=1
      fi
    done
    ((n = n - 1))
    [[ $swapped ]] || break
  done

  for value in "${values[@]}"; do
    echo "$value"
  done
}

# using standard sorting tool here
sortBySales_unix() {
  sort -t= -n -k2
}

# bubble sort in Bash
sortBySales() {
  local values=($(cat))
  local n=${#values[@]}
  local swapped i tmp

  while :; do
    swapped=
    for ((i = 1; i < n; i++)); do
      sale1=${values[i - 1]#*=}
      sale2=${values[i]#*=}
      if (($sale1 > $sale2)); then
        tmp=${values[i - 1]}
        values[i - 1]=${values[i]}
        values[i]=$tmp
        swapped=1
      fi
    done
    ((n = n - 1))
    [[ $swapped ]] || break
  done

  for value in "${values[@]}"; do
    echo "$value"
  done
}

userInput='y'
while [[ $userInput == [yY] ]]; do
  clear                                             
  echo
  printf "\e[31m################################################################\n"
  echo
  printf "\e[32m 1. Number of sales man\n"
  printf "\e[35m 2. Save data into text file\n"
  printf "\e[33m 3. Sort Alphabetticaly or by Sales\n"
  printf "\e[37m 4. Objectives\n"

  echo
  printf "\e[31m################################################################\n"
  read -p " Available Choices [1-4] type \"exit\" to exit :" cases
  printf "\e[31m################################################################\n"
  ########################################################
  case $cases in
  1)
    banners
    echo "The number of sales man is" ${#salesPeople[@]}
    ;;
  2)
    banner
    echo -n "Enter your name and press [ENTER]: "
    read name

    #check if userinput is exit, if so program stops
    if [[ $name == "exit" ]]; then
      break
    fi

    # asks user for input and saves output to salesPeople variable
    while :; do
      read -p "Enter sales and press [ENTER] " sales
      if [[ $sales =~ ^[0-9]+$ ]]; then break; fi
      echo "Does not look like a number: $sales"
    done

    NUM1=1000000
    NUM2=99999

    # if userinput is greater or euqal to NUM1 then
    # display Bonus 1500 and the array
    if [ "$sales" -ge "$NUM1" ]; then
      echo "Bonus 1500"
      salesPeople[$name]=$((sales + 1500))

      # if userinput is between 1-99 then
      # display No Bonus and the array
    elif [ "$sales" -le "$NUM2" ]; then
      echo "No Bonus"
      salesPeople[$name]=$sales

      # if userinput is between 100-999 then
      # display Bonus 750 and the array
    else
      echo "Bonus 750"
      salesPeople[$name]=$((sales + 750))
    fi

    echo -n "Would you like to save data into text file (Y/N): "
    read output

    if [[ $output == [yY] ]]; then
      displaySalesPeople | tee "$sales_file"
      echo "Your file was succesfully saved"
    elif [[ $output == [nN] ]]; then
      displaySalesPeople
    fi
    ;;
  3)
    banner
    echo -n "To sort Alphabetticaly or Sales (A/S): "
    read user

    if [[ $user == [aA] ]]; then
      displaySalesPeople | sortByAlphabet
    elif [[ $user == [sS] ]]; then
      displaySalesPeople | sortBySales
    fi
    ;;
  4)
    banner
    Objectives
    ;;
  exit)
    exit 0
    ;;
  *)
    echo "Your choice is not available"
    exit 1
    ;;
  esac
  echo -n "Would you like to go back to the main menu(Y/N):"
  read userInput
done
