#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  #echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  #echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
  #insert every row in games table
  TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAMS ]]
    then
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[  INSERT_TEAM == "0 1" ]] 
        then 
          echo SUCCESFULL INSERT INTO teams, $WINNER
        fi  
    fi
  fi

  OPPO=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
  then
    if [[ -z $OPPO ]]
    then
      INSERT_OPPO=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPO == "INSERT 0 1" ]] 
      then
          echo Insert Succesfull into Teams, $OPPONENT
      fi
    fi 
  fi
  

  #CONSULTAR EL id DE CADA EQUIPO
  ID_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  ID_OPPO=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  #INGRESAR LOS GAMES
  if [[ -n $ID_TEAM || -n $ID_OPPO ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$ID_TEAM', '$ID_OPPO', '$WINNER_GOALS', '$OPPONENT_GOALS')")
      if [[  $INSERT_GAMES == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR
      fi
    fi
  fi
done

