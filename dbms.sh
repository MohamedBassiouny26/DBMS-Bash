#!/bin/bash

### Connecting to an Existing Database Function
function connectDatabase 
{

  echo -e "Enter Database Name: \c"
  read name

  cd ./Database/$name 2> /dev/null

  if [[ $? == 0 ]]
	then
    echo "Connected to $name Successfully"
  else
    echo "Database $name wasn't found"

  fi
}


### Dropping an existing Database Function
function dropDatabase {
  echo -e "Enter Database Name: \c"
  read name

  rm -r ./Database/$name 2> /dev/null

  if [[ $? == 0 ]]
	then
    echo "Successful Drop for $name Database"
  else
    echo "Database Not found"
  
 fi
}

