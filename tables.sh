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
        2)  #insert into table
            insertIntoTable
            tableMenue;;
        3)  #drop table
            createTable;;    
        *) echo " Please Select from menu " ; mainMenu;
        esac
    done
}
function createTable {
    echo "Please,Enter Table Name"
    read tableName
    if [ -f $tableName ]
    then
        echo "Table already exist"
        createTable
    else
        touch $tableName
    fi
    echo "Enter number of columns"
    read colNum
    typeset -i i=0
    columns=""
    while [ $i -lt $colNum ] 
    do
        echo "Enter column Name"
        read colName
        echo "Enter coumn type"
        read colType
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
tableMenue