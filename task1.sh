#!/bin/bash
OUTPUT="accounts_new.csv"
DOMAIN="@abc.com"
LINE_NUMBER=0
#First pass
while read -r line; do
  #skipping first row
  LINE_NUMBER=$((LINE_NUMBER+1))
  if [ $LINE_NUMBER -eq 1 ]; then
    echo $line > $OUTPUT".tmp"
    continue
  fi
  #split line to columns
  IFS=',' col=($line)
  #getting user column, cleaning extra spaces with awk magic
  user=$(echo "${col[2]}" | awk '{$1=$1}1') 
  #split user column onto name and surname, capitalize first letter
  IFS=' ' user=($user)
  name="${user[0]}" surname="${user[1]}"
  #compose email address
  fst_letter=${name:0:1}
  mailbox="${fst_letter,}${surname,,}"
  #writing changes to the file
  echo "${col[0]},${col[1]},${name^} ${surname^},${col[3]},$mailbox$DOMAIN,${col[5]}" >>$OUTPUT".tmp"
  #finding same name users
  namesake=$(grep -i "$mailbox" $OUTPUT".tmp" | wc -l)
  if [ $namesake -gt 1 ]; then
    mailsake+=($mailbox)
  fi
done <$1
#sorting an array and making all elements unique
emails=($(echo ${mailsake[@]} | tr ' ' '\n' | sort -u | tr '\n' ' '))

#Second pass
while read -r line; do
  for email in "${emails[@]}"; do
    if [[ $line =~ $email ]]; then
      IFS=',' col=($line)
      line="${col[0]},${col[1]},${col[2]},${col[3]},$email${col[1]}$DOMAIN,${col[5]}"
      break
    fi
  done
  IFS=' '
  echo $line >> $OUTPUT
done <$OUTPUT".tmp"
rm -f $OUTPUT".tmp"
