#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_game --tuples-only -c"

NUMBER=$(( $RANDOM%1000 ))
echo "Enter your username:"
read USER_NAME

# check whethere the username is present or not
USER_NAME_PRESENT_RESULT=$($PSQL "select games_played,best_game FROM users WHERE user_name='$USER_NAME'")
# if userame is not present in database
if [[ -z $USER_NAME_PRESENT_RESULT ]]
then
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
# if the username is not present in database
else
    echo $USER_NAME_PRESENT_RESULT | while read GAMES BAR BEST
    do
        echo "Welcome back, $USER_NAME! You have played $GAMES games, and your best game took $BEST guesses."
    done
fi
echo "Guess the secret number between 1 and 1000:"
read GUESS