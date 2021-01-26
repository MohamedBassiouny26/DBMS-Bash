#!/bin/bash
arr=(Create List table)
#main function
function mainMenu {
PS3="Enter a Choice : "
echo  +.......Enter Your Choice........+
select element in ${arr[*]}
do 
    case $REPLY in 
        1)  #create new database
            createDB
            mainMenu;;  
        2)  #List databases
            listDBs;;
        3)  #Create table
            createTable;;    
        *) echo " Please Select from menu " ; mainMenu;
    esac
done
}
function createDB {
    echo Enter Name of New Database
    read Name
        if [ -d $Name  ]
        then
            echo This Database is already created
        else
            mkdir $Name
            echo Database created successfully!
        fi
}
function listDBs {
    ls
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
        columns+=$colName:$colType;
        i=$i+1
    done
    echo $columns>>$tableName;
}
mainMenu


