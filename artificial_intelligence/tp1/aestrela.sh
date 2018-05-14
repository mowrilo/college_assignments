#!/bin/bash

if [ $6 = 1 ]
then
    ./exe $1 a_star manhattan $2 $3 $4 $5 # > output
elif [ $6 = 2 ]
then
    ./exe $1 a_star octile $2 $3 $4 $5 # > output
else
    echo "Esta heuristica não existe!"
fi


