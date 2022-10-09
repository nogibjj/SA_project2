#!/bin/bash
dir='data_cleaning'
if [[ ! -e $dir ]]; then
    mkdir $dir
    echo "directory was created"
elif [[ $(ls -A $dir) ]]; then
    rm -v $dir
    echo "directory was emptied"
fi

#remove Survived column from train.csv
cut -d ',' -f 2 --complement data/train.csv > data_cleaning/cols_train.csv

#merge train and test
( cat data/test.csv ; tail -n +2 data_cleaning/cols_train.csv ) >> data_cleaning/all_data.csv

#clean missing rows
echo "Would you like to drop missing values? [yes/no]"
read drop_rows
if [[ "$drop_rows" == "yes" ]]
then
    #drop rows with any missing values
    awk -F"," '{for(i=1;i<=NF;i++){if($i==""){next}}}1' data_cleaning/all_data.csv >data_cleaning/clean_data.csv
    echo "Rows have been dropped - see clean_data.csv"
    current_data='data_cleaning/clean_data.csv'
else [[ "$drop_rows" == "no" ]]
    echo "You chose not to drop missing values. Moving to next step."
    current_data='data_cleaning/all_data.csv'
fi

#truncate data
echo "Would you like to split data based on gender? [yes/no]"
read split_data
if [[ "$split_data" == "yes" ]]
then
    #check if directory exists and is empty, otherwise empties or creates directory
    split_dir='data_split'
    if [[ ! -e $split_dir ]]
    then
        mkdir $split_dir
        echo "directory for split data was created: data_split"
    elif [[ $(ls -A $split_dir) ]]
    then
        rm -v $split_dir
        echo "data_split was emptied"
    fi
    #split data into files depending on gender
    awk -F ',' '$5 == "female" {print > ("data_split/female_only.csv"); next} {print > ("data_split/male_only.csv")}' $current_data
else
    echo "You chose not to split the dataset, your cleaned data is under: $current_data"
fi