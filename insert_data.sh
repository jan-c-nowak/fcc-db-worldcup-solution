#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# echo $($PSQL "DELETE FROM teams")

cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # Check if winner is in the table already
    WIN_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    # If not: Add winner team to team
    if [[ -z $WIN_NAME ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi

    # Check if winner is in the table already
    OPP_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # If not: Add winner team to team
    if [[ -z $OPP_NAME ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi

    # Add info to games table
    # Find Winner's ID from teams
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # Find Opponent's ID from teams
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # Insert match into games table
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_GOALS, $OPP_GOALS)")
  fi
done