#! /bin/bash


###############################################################################
# Global variables
###############################################################################
trashDir=~/Trash


###############################################################################
# functions
###############################################################################
### make sure that trash directory exisit
function checkTrash() {
    if [[ -d $trashDir ]]; then
        echo "trash is already exist"
    else
        echo "creating a Trash ..."
        mkdir $trashDir
    fi
}


### Make sure that passed file to delete is already exist and return 0 if no errors, 1 for not found file
function isFilesExist() {
    errorFlag=0
    numOfFiles=$@
    if [[ $numOfFiles = 0 ]]; then
        echo "no file passed."
    else
        for f in ${numOfFiles[@]};
        do
            if [[ -f $f ]]; then
                echo "$f checking..."
                echo "$f found."
            else
                errorFlag=1
                break
            fi
        done
    fi
    return $errorFlag
}


### Gzipped a file
function deleteFileTemp() {
    checkTrash
    echo "we are done there"
    numOfFiles=$@
    for f in ${numOfFiles[@]};
    do
        gzip $f
        mv "$f.gz" $trashDir
    done
}

### periodiclly checking
function deletFilepermenent() {
    allFiles=$(ls $trashDir)
    currentDay=$(date +"d")
    
    for f in $allFiles;
    do
        fileDay=$(date -r $trashDir/$f +"%d")
        
        res=$(( $currentDay - $fileDay ))
        
        if [[ $res = 2 || $res > 2 ]]; then
            $("rm $trashDir/$f")
        fi
    done
}


###############################################################################
# main logic
###############################################################################

isFilesExist $@

if [[ ! $? = 0 ]]; then
    echo "no such file(s) with that name"
else
    # deleteFileTemp $@
    deletFilepermenent
fi
