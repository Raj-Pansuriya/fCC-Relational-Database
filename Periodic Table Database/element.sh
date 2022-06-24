#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
ARG=$1
if [[ $ARG ]]
then
	# ARG 1 is a number
	if [[ $ARG =~ ^[0-9]+$ ]]
	then
		# search in database
		ELEMENT_SEARCH_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ARG")

	# ARG 1 is a string
	elif [[ $ARG =~ ^[a-zA-Z]+$ ]]
	then
		# ARG 1 is a string of less tahn or equal to 2 letters
		if (( ${#ARG} <= 2 ))
		then
			# search in database
			ELEMENT_SEARCH_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$ARG'")
			
		
		# ARG 1 us a string of more than 2 letters
		else
			# search in database
			ELEMENT_SEARCH_RESULT=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$ARG'")
			
		fi
	fi
	
	# if element not found
	if [[ -z $ELEMENT_SEARCH_RESULT ]]
	then
		echo "I could not find that element in the database."
	else
		# if element is found read it's values into different variables
		echo $ELEMENT_SEARCH_RESULT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
		do
			# print the statement as per user stories
			echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
		done
	fi
else
	echo "Please provide an element as an argument."
fi
