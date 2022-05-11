#!/bin/bash

count=0;
mkdir .home
dir=`ls .home`
rec(){
    echo " this is $1"
     find . -name '*.gz' | while read filename; do -execdir gzip -d $1 echo "$filename"'{}' ';'
     find . -name '*.zip' -execdir unzip $1'{}' ';'
     find . -name '*.bzip2' -execdir bzip2 $1'{}' ';'
     find . -name '*.cmpr' -execdir  uncompress $1'{}' ';'

}


while getopts "rv" options; do
    case "${options}" in         
        r)                       
        recursive=true;   
        ;;
        v)                       
        verbose=true;
        ;;
    esac
done

for argument in "$@" 
do
    if [[ $argument == "-r" || $argument == "-v" ]]; then
        continue
    fi
    echo "$@"
    type=$(file -i $argument);
    echo "$type"

    case "$type" in 
        *application/x-bzip2*)  bzip2 -d "$argument"
                                if [ "$verbose" = true ]; 
                                then 
                                echo "Unpacking:" "$argument" ;
                                fi
                                if [ "$recursive" = true ];
                                then  rec "$dir" ;
                                fi  ;;
        *application/zip*)      unzip  -d .home/ "$argument" 
                                if [ "$verbose" = true ]; 
                                then 
                                echo "Unpacking:" "$argument" ;
                                fi 
                                if [ "$recursive" = true ];
                                then  rec "$dir";
                                fi 
                                ;;
        *application/x-compress*) uncompress "$argument" 
                                if [ "$verbose" = true ]; 
                                then 
                                echo "Unpacking:" "$argument" ;
                                fi 
                                if [ "$recursive" = true ];
                                then rec "$dir";
                                fi;;
        *application/gzip*)     gzip -d "$argument" 
                                if [ "$verbose" = true ]; 
                                then 
                                echo "Unpacking:" "$argument" ;
                                fi
                                if [ "$recursive" = true ];
                                then rec "$dir";
                                fi ;;
        *)                      if [ "$verbose" = true ]; 
                                then 
                                echo "ignoring:" "$argument" ;
                                fi
                                ((count=count+1))
                                ;;  

    esac
    
done
echo "$count"


