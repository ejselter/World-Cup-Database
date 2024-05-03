#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'") 
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert name of team 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted winner into teams, $WINNER"
      fi
    fi
  fi
  if [[ $OPPONENT != "opponent" ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'") 
    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert name of team 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted opponent into teams, $OPPONENT"
      fi
    fi
  fi 
#insert each row into games
  if [[ $YEAR != "year" ]]
  then
    #get team ids
    echo "'$WINNER' name"
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'") 
    echo "'$WINNER' name and id is $WINNER_ID"
    OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #insert data into rows
    INSERT_ROW=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND',$WINNER_ID, $OPPO_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_ROW == "INSERT 0 1" ]]
    then
      echo "Inserted row into games for year, $YEAR"
    fi
  fi
done
