#!/bin/bash
PS3="[$1] :"
cd $1
function tableMenue {
    select option in "Create table" "insert into table" "drop table"
    do 
        case $REPLY in 
        1)  #create new table
            createTable
            tableMenue;;  
        2)  #List databases
            listDBs;;
        3)  #Create table
            createTable;;    
        *) echo " Please Select from menu " ; mainMenu;
        esac
    done
}
function createTable {
    echo Please,Enter Table Name
    read tableName
    if [ -f $tableName ]
    then
        echo Table already exist
        createTable
    else
        touch $tableName
    fi
    echo Enter number of columns
    read colNum
    typeset -i i=0
    columns="name:type;"
    while [ $i -lt $colNum ] 
    do
        echo Enter column Name
        read colName
        echo Enter coumn type
        read colType
        if [ -z $pk ]
        then
            echo Primarykey??
            select answer in "yes" "no"
            do 
                case $REPLY in 
                1) 
                    pk=$colName
                    break;;
                2)  break;;
                *) echo " Please Select from yes or no " ;;
                esac
            done
        fi
        columns+="$colName:$colType;"
        i=$i+1
    done
    echo $columns>>$tableName;
    echo pk:$pk>>$tableName;
    tableMenue
}
tableMenue