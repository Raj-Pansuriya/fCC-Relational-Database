#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~ SALON APPOINTMENT SCHEDULER ~~~\n"

SERVICE_MENU(){
	if [[ $1 ]]
	then
		echo -e "$1"
	fi
	# get available services from the database
	AVAILABLE_SERVICES=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id")

	# display available services
	echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
	do
		echo "$SERVICE_ID) $SERVICE_NAME"
	done
	read SERVICE_ID_SELECTED

	case $SERVICE_ID_SELECTED in
	1 | 2 | 3 | 4 | 5) APPOINTMENT_MENU $SERVICE_ID_SELECTED ;;
	*) SERVICE_MENU "\nI could not find that service. What would you like today?" ;;
	esac
}

APPOINTMENT_MENU() {
	SERVICE_ID=$1
	echo -e "\nWhat's your phone number?"
	read CUSTOMER_PHONE

	# get customer id
	CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

	# if customer does not exist
	if [[ -z $CUSTOMER_ID ]]
	then
		# get new customer name
		echo -e "\nI don't have a record for that phone number, what's your name?"
		read CUSTOMER_NAME

		# insert customer info in database
		INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
	fi

	# get new customer id
	CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

	# get customer name
	CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")

	# get service name from database
	SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")

	# get appointment time
	echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
	read SERVICE_TIME

	# book an appointment
	BOOK_APPINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")

	# confirmation for the appointment
	echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}

SERVICE_MENU "Welcome to My Salon, how can I help you?"