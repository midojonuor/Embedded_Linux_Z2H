#! /bin/bash


##################################################################################
# Global Variables
##################################################################################
### name of database file
DB_file=.phonebook_db




##################################################################################
# utilites
##################################################################################
function isContactExist() {
	#statements
	contactInDB=$(grep "$1.*" $DB_file)
	contactInDB="$( echo $contactInDB | cut -d: -f1 )"

	if [[ $contactInDB = $1 ]]; then
		return 1
	else
		return 0
	fi
}

### check if database file not exist, ask user to create one
function checkDataBase() {
	if [[ ! -f "$DB_file" ]]; then
		echo "WARNING!!!"
		echo "Data base file does not exist"
		read -p "Create Database file now[y/n]?" check

		if [[ $check = y ]]; then
			touch "$DB_file"
			clear
		else
			echo "Sorry cannot start without database file."
			exit
		fi
	fi
}


##################################################################################
# Functions
##################################################################################

### Insert new contact name and number
function insertName () {
	read -p "Enter contact name: " newName
	read -p "Enter contact number: " newNumber

	if [[ $newName =~ ^[+-]?[0-9]+$ ]]; then
		#statements
		echo "Invalid Name for new contact"
	else
		isContactExist $newName
		temp=$?
		if [[ $temp = 1 ]]	; then
			echo "$newName is already exist in phonebook."
		elif [[ $newNumber =~ ^[+-]?[0-9]+$ ]]; then
			echo "$newName:$newNumber" >> $DB_file
		else
			echo "Invalid number."
		fi
	fi


}


### View all saved contacts details
function viewAllContact() {

	data="$(cat $DB_file)"
	#echo "${data}"
	IFS=$'\n'
	for line in ${data}; do
		echo "$( echo $line | cut -d: -f1 )        $( echo $line | cut -d: -f2 )"
	done
	IFS=$' '
}


### Search by contact name
function searchByContact() {
	#statements
	read -p "Enter contact name to find: " nameToFind

	if [[ $nameToFind =~ ^[+-]?[0-9]+$ ]]; then
		echo "Invalid Name for new contact"
	else

		currentName=0
		currentName="$(grep "$nameToFind.*" $DB_file)"

		IFS=$'\n'

		for line in ${currentName}; do
			echo "$( echo $line | cut -d: -f1 )        $( echo $line | cut -d: -f2 )"
		done

		IFS=$' '
	fi
}


### Delete all records
function deleteAllRecords() {
	#statements
	echo "You are about to remove all records from phonebook."
	echo "This operation cannot undo it."
	read -p "Do you want to continue[y/n]?" input

	if [[ $input = 'y' ]]; then
		echo > $DB_file
		echo "3ala el donya el salankaty XD."
	else
		echo "yb2a nbtl l3b b2a X("
	fi
}


### Delete onle one contact name
function deleteContactByName() {
	read -p "Enter contact name to remove: " nameToFind

	isContactExist $nameToFind
	temp=$?

	if [[ $temp = 1 ]]; then
		sed -i "/$nameToFind/d" $DB_file > /dev/null
		echo "$nameToFind removed"

	else
		echo "Contact not found."
	fi
}




##################################################################################
# Main Logic
##################################################################################

checkDataBase

case $1 in
	-i ) insertName
		;;

	-v ) viewAllContact
		;;

	-s ) searchByContact
		;;

	-e ) deleteAllRecords
		;;

	-d ) deleteContactByName
		;;


	*)
	echo "choose one of the following options:"
	echo "	-i	Insert new contact name and number."
	echo "	-v	View all saved contacts details."
	echo "	-s	Search by contact name."
	echo "	-e	Delete all records."
	echo "	-d	Delete only one contact name."
esac
