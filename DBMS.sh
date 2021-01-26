#!/bin/bash
arr=(Create List)
#main function
function mainMenu {
PS3="Enter a Choice : "
echo  +.......Enter Your Choice........+
select element in ${arr[*]}
do 
    case $REPLY in 
        1)  #create new database
            createDB
            mainMenu
            ;;  
        2)  #List databases
            listDBs;;  
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
mainMenu


