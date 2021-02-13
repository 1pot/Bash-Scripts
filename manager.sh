#!/usr/bin/env bash
function banner(){
echo -e "\t\t\e[38m#     #"                                        
echo -e "\t\t\\e[38m##   ##   ##   #    #   ##    ####  ###### #####  "
echo -e "\t\t\\e[38m# # # #  #  #  ##   #  #  #  #    # #      #    # "
echo -e "\t\t\\e[38m#  #  # #    # # #  # #    # #      #####  #    #" 
echo -e "\t\t\\e[38m#     # ###### #  # # ###### #  ### #      #####"  
echo -e "\t\t\\e[38m#     # #    # #   ## #    # #    # #      #   # "
echo -e "\t\t\\e[38m#     # #    # #    # #    #  ####  ###### #    #"
}

function mainMenu(){
clear                           
banner                  
printf "\e[31m################################################################################\n"
printf "\t\t\t\t\e[31m#\e[37mMain menu\e[31m#\n"
printf "\e[31m################################################################################\n"
printf "\e[32m1. Archive user\n"
printf "\e[32m2. Add user\n"
printf "\e[32m3. Objectives\n"
printf "\e[31m################################################################################\n"
read -p "Available Choices [1-2] type \"exit\" to exit :" cases
printf "\e[31m################################################################################\n"
}

function addUsersMenu(){
printf "\e[31m################################################################################\n"
printf "\t\t\t\t\e[31m#\e[37mSecondary Menu\e[31m#\n"
printf "\e[31m################################################################################\n"
printf "\e[32m1. Add new group\n"
printf "\e[32m2. Add new user\n"
printf "\e[31m3. Delete users\n"
printf "\e[31m4. Delete groups\n"
printf "\e[33m5. Edit users\n"
printf "\e[33m6. Edit groups\n"
printf "\e[31m################################################################################\n"
printf "\e[37mType \e[31m(exit) \e[33mTo exit this environment\n"
printf "\n"
printf "\e[37mPlease enter your choice: "
read choice1
}

function archiveUsers(){
printf "\e[31m################################################################################\n"
printf "\t\t\t\t\e[31m#\e[37mSecondary Menu\e[31m#\n"
printf "\e[31m################################################################################\n"
printf "\e[32m1. Enter the day\n"
printf "\e[33m2. Enter the time\n"
printf "\e[37m3. Enter frequency to archive the files\n"
printf "\e[35m4. The source and destination locations\n"
printf "\e[39m5. Create a new file and copy the data in it\n"
printf "\e[31m################################################################################\n"
printf "\e[37mType \e[31m(exit) \e[33mTo exit this environment\n"
printf "\n"
printf "\e[37mPlease enter your choice: "
read choice1
}

function addGroup(){
clear
if [ $(id -u) -eq 0 ]; then
	echo -n "Enter name for the new [GROUP]: "
	read groupname
	egrep -q "^$groupname:" /etc/group
	if [ $? -eq 0 ]; then
		echo "$groupname exists!"
		exit 1
	else
		groupadd $groupname
		[ $? -eq 0 ] && echo "group $groupname has been added!" || echo "Failed attempt..."
		printf "\e[32mGroup list updated\n"
		getent group {1000..60000} | cut -d: -f1
	fi
else
	echo "try again as root"
	exit 2
fi
}

function addUser(){
clear
if [ $(id -u) -eq 0 ]; then
	echo -n "Enter the username: "
	read username
	echo -n "Enter the password: "
	read -s password
	printf "\n"
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -d -p  $password $username
		echo "password encrypted ~> $pass"
		[ $? -eq 0 ] && echo "user $username has been added!" || echo "Failed attempt..."
		echo
		printf "\e[32mUsers list\n"
		getent passwd {1000..60000} | cut -d: -f1
		echo 
	fi
else
	echo "try again as root"
	exit 2
fi
}

function delUser(){
clear
echo
printf "\e[32mUsers list\n"
getent passwd {1000..60000} | cut -d: -f1
echo 
if [ $(id -u) -eq 0 ]; then
		echo -n "Username to [DELETE]: "
		read username
		egrep "^$username" /etc/passwd >/dev/null
	if [ $? -ne 0 ]; then
		echo "User $username doesn't exists!"
		exit 1
	else
		deluser $username
		[ $? -eq 0 ] && echo "User $username deleted!" || echo "Failed to delete..."	
		echo
		printf "\e[32mUsers list\n"
		getent passwd {1000..60000} | cut -d: -f1
		echo 
		 
	fi
else
	echo "try again as root"
	exit 2
fi
}

function delGroup(){
clear
printf "\e[32mGroup list\n"
getent group {1000..60000} | cut -d: -f1
if [ $(id -u) -eq 0 ]; then
		echo -n "Groupname to [DELETE]: "
		read groupname
		egrep -q "^$groupname:" /etc/group
	if [ $? -ne 0 ]; then
		echo "Group $groupname doesn't exists!"
		exit 1
	else
		groupdel $groupname
		[ $? -eq 0 ] && echo "group $groupname deleted!" || echo "Failed to delete..."	
		printf "\e[32mGroup list updated\n"
		getent group {1000..60000} | cut -d: -f1
	fi
else
	echo "try again as root"
	exit 2
fi
}

function editUser(){
printf "\e[32mUsers list\n"
getent passwd {1000..60000} | cut -d: -f1
echo 
if [ $(id -u) -eq 0 ]; then
	echo -n "Enter users username to edit: "
	read username
	passwd $username
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -ne 0 ]; then
		echo "User $username doesn't exists!"
		exit 1
	else
		echo -n "Enter new username: "
		read updatedUsername
		usermod -l $updatedUsername $username
		[ $? -eq 0 ] && echo "User $username updated to $updatedUsername!" || echo "Failed to edit..."
		echo
		printf "\e[32mUsers list\n"
		getent passwd {1000..60000} | cut -d: -f1
		echo 
	fi
else 
	echo "try again as root"
	exit 2
fi
}

function editGroup(){
clear
printf "\e[32mGroup list\n"
getent group {1000..60000} | cut -d: -f1
if [ $(id -u) -eq 0 ]; then
	echo -n "Enter users groupname to edit: "
	read groupname
	egrep -q "^$groupname:" /etc/group
	if [ $? -ne 0 ]; then
		echo "Group $groupname doesn't exists!"
		exit 1
	else
		echo -n "Enter new groupname [NAME]: "
		read updatedGroupName
		groupmod -n $updatedGroupName $groupname
		[ $? -eq 0 ] && echo "group $groupname updated to $updatedGroupName!" || echo "Failed to edit..."
		printf "\e[32mGroup list updated\n"
		getent group {1000..60000} | cut -d: -f1
	fi
else 
	echo "try again as root"
	exit 2
fi
}

userInput='y'
while [[ $userInput == [yY] ]]; do
  mainMenu
  case $cases in
  1)
    clear
    while :
    do
	archiveUsers
    case $choice1 in
        "1")
		
          
          break
        ;;
        "2")
          
          break
        ;;
        "3")
          
          break
        ;;
        "4")
          
          break
        ;;
        "5")
         
        ;;
        "exit")
        break
 esac
 done

  ;;
  2)
	clear
    while :
    do
    addUsersMenu
    case $choice1 in
        "1")
		# add group 
        addGroup
        ;;
        "2")
		# add new user
		addUser
        ;;
        "3")
		#delete user
		delUser
        ;;
        "4")
		#delete group
        delGroup
        ;;
        "5")
         #edit user
         editUser
        ;;
        "6")
		 #edit group
         editGroup
        ;;
        "exit")
        break
        esac
        done
  ;;
  3)
  echo "object"
  ;;
  bye)
    exit 0
    ;;
  *)
    echo "Your choice is not available"
    exit 1
    ;;
  esac
  echo -e -n "Would you like to go back to the main menu(Y/N): \e[39m"
  read userInput
done 