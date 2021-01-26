#!/bin/bash

### Connecting to an Existing Database Function
function connectDatabase 
{

  echo -e "Enter Database Name: \c"
  read name

  cd ./Database/$name 2> /dev/null

  if [ $? -eq 0 ]
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

  if [ -d $name ]
	then
    echo "Successful Drop for $name Database"
  else
    echo "Database Not found"
  
 fi
}

### Drop Table Function
function dropTable {
  echo -e "Enter table name to drop: \c";
  read tname;
  rm tname 2> /dev/null
  
  if [ -f $tname ]
  then
    echo "Table Dropped Successfully!"
  else
    echo "Cannot Drop Table $tname, may be not exists"
  fi
}

