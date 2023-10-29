#!/bin/bash

## we are runnig python scripts because for bash it is too complicated
#python3 ./task1.py $1 2>&2
#nope because we thought it was too complicated for bash, on bash it is twice time shorter!
line_number=0
while read -r line; do
  #skipping first row
  line_number=$((line_number+1))
  if [ $line_number -eq 1 ]; then
    echo $line > accounts_new.csv
    continue
  fi
  #split line to columns
  IFS=',' col=($line)
  #getting user column, cleaning extra spaces with awk magic
  user=$(echo "${col[2]}" | awk '{$1=$1}1') 
  #split user column onto name and surname, capitalize first letter
  echo ${col[3]} ${col[4]}
  IFS=' ' user=($user)
  name="${user[0]}" surname="${user[1]}"
  #compose email address
  name_letter=${name:0:1}
  mailbox="${name_letter,}${surname,,}"
  domain="@abc.com"
  #finding same name users
  namesake=$(grep -iP "$name\s+$surname" $1 | wc -l)
  if [ $namesake -gt 1 ]; then
    mailbox=$mailbox${col[1]}
  fi
  echo "${col[0]},${col[1]},${name^} ${surname^},${col[3]},$mailbox$domain,${col[5]}" >>accounts_new.csv
done <$1
