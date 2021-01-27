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

    while [ $i -lt $colNum ] 
    do
        echo Enter column Name
        read colName
        echo "Enter column type"
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
                2) break;;
                *) echo " Please Select from yes or no " ;;
                esac
            done
        fi
    if [ $i -eq $colNum ] 
    then
          struct=$struct$colName
        else
        separator=":"

              struct=$struct$colName$separator
        fi

        i=$i+1
    done
  echo -e $struct >> $tableName
    tableMenue
}
tableMenue