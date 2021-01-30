#!/bin/bash
PS3="[$1] :"
function tableMenue {
    select option in "Create table" "insert into table" "drop table" "select table" "Update table"
    do 
        case $REPLY in 
        1)  #create new table
            createTable
            tableMenue;;  
        2)  #insert into table
            insertIntoTable
            tableMenue;;
        3)  #drop table
            dropTable;;    
        4)  #select table
            selectAll;;    
        5) updateTable;;
        *) echo " Please Select from menu " ; mainMenu;
        esac
    done
}
function createTable {
    echo "Please,Enter Table Name"
    read tableName
    # if [ -f $tableName ]
    # then
    #     echo "Table already exist"
    #     tableMenue
    # else
    #     touch $tableName
    # fi
    echo "Enter number of columns"
    read colNum
    testInput $colNum "int"
    if [ $? -eq 0 ]
    then
    echo "Please enter number of columns in integer type"
    tableMenue
    fi
     if [ -f $tableName ]
    then
        echo "Table already exist"
        tableMenue
    else
        touch $tableName
    fi
    typeset -i i=0
    columns=""
    while [ $i -lt $colNum ] 
    do
        echo "Enter column Name"
        read colName
        echo "Select column type"
        select type in "int" "string"
        do
            colType=$type
            break
        done
        # read colType
        if [ -z $pk ]
        then
            echo "Primarykey??"
            select answer in "yes" "no"
            do 
                case $REPLY in 
                1) 
                    pk=$colName
                    colName+="(pk)"
                    break;;
                2)  break;;
                *) echo " Please Select from yes or no " ;;
                esac
            done
        fi
        columns+="$colName:$colType;"
        i=$i+1
    done
    printf $columns>>$tableName;
    # echo pk:$pk>>$tableName;
    tableMenue
}    

function insertIntoTable {
    tables=`ls`;
    echo "Please Select Table To Insert Into :"
    select table in $tables;
    do
        if [[ -f $table ]]
        then
            # printf "\n">>$table;
            insert $table;
            break;
        else
            echo "Please,select exist table"
        fi
        i=$i+1;
    done
}
function insert {
    typeset -i i=1;
    colName=`cut -d";" -f $i $1|cut -d":" -f 1|head -1`;
    colType=`cut -d";" -f $i $1|cut -d":" -f 2|head -1`;
    field='';
    while [[ -n $colName ]]
    do
        echo "Enter Value of $colName";
        read value
        testInput $value $colType
        if [ $? -eq 1 ]
        then
            field+="$value;"
        else
            echo "Somthing Wrong!"
            tableMenue
        fi
        i=$i+1;
        colName=`cut -d";" -f $i $1|cut -d":" -f 1|head -1`; 
        colType=`cut -d";" -f $i $1|cut -d":" -f 2|head -1`;
    done
    printf "\n">>$1
    printf "$field">>$1
}
function testInput {
    # echo $1
    case $1 in 
         [a-z]* ) type="string";;
         [0-9]* ) type="int";;
    esac
     if [[ "$type" == "$2" ]]
     then
        return 1
     else
        return 0
     fi
}
function selectAll {
  echo -e "Enter Table Name: \c"
  read tName
  column -t -s ';' $tName 2> /dev/null
  if [[ $? != 0 ]]
  then
    echo "Error Displaying Table $tName"
  fi
  tableMenue
}
### Drop Table Function
function dropTable {
  echo -e "Enter table name to drop: \c";
  read tname;
  rm $tname .$tname 2> /dev/null

  if [ -f $tname ]
  then
    echo "Table $tname Dropped Successfully"
  else
    echo "Cannot Drop Table $tname, table may not exists"
  fi
}
function updateTable {
    echo "enter table name"
    read tableName
    if [ ! -f $tableName ]
    then
    echo "table may not exists"
    tableMenue
    fi
    echo "Enter condition column "
    read colName
    fieldNumber=`awk -v RS=';' "/$colName/ "'{print NR}' $tableName`
    if [ -z $fieldNumber ]
    then
    echo "col not exist"
    tableMenue
    fi
    echo "enter conditon value "
    read value
    #line number
    searchResult=`cut -d ";" -f $fieldNumber $tableName 2>/dev/null|awk "/$value/ "'{print NR}' $tableName`
    echo $searchResult|cut -d " " -f 1 
    if [ -z $searchResult ]
    then
    echo "value not exist"
    tableMenue
    fi
    echo "Enter update col : "
    read colUpdate
    updateNum=`awk -v RS=';' "/$colUpdate/ "'{print NR}' $tableName`
    if [ -z $updateNum ]
    then
    echo "col not exist"
    tableMenue
    fi
    echo $updateNum
    colType=`cut -d";" -f $updateNum $tableName|cut -d":" -f 2|head -1`;
    echo $colType
    # echo $updateNum #filed number
    echo "enter new value"
    read newValue
    testInput $newValue $colType
    if [ $? -eq 0 ]
    then
        echo "Wrong Type"
        tableMenue
    fi
    oldValue=$(awk 'BEGIN{FS=";"} {
     if(NR=="'$searchResult'"){
         print $'$updateNum';     
         }
      }' $tableName)
    sed -i ''$searchResult's/'$oldValue'/'$newValue'/g' $tableName 2>>/dev/null
}
tableMenue
