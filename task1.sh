#!/bin/bash
OUTPUT="contacts_new.csv"
DOMAIN="@abc.com"
namesake=($(awk -v out="$OUTPUT" -v dom="$DOMAIN" 'BEGIN {
        FS = OFS = ","
	#insert headline
        print("id,location_id,name,title,email,department") > out
}
NR > 1 {
	#fields preparation
        split($3, username, " ")
        mailbox = tolower(substr(username[1], 1, 1) username[2])
	sub(/./, toupper(substr(username[1], 1, 1)), username[1])
        sub(/./, toupper(substr(username[2], 1, 1)), username[2])
	#formation email's list
        a[mailbox] += 1
	#entering data
        print($1, $2, username[1] " " username[2], $4, mailbox dom, $6) > out
}
END {
        for (key in a) {
                if (a[key] > 1) {
                        keys = keys key " "
                }
        }
        print keys
}' $1))


for email in "${namesake[@]}"; do
  email=$email
  sed -i "s/\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\($email$domain\)/\1,\2,\3,\4,$email\2/" $OUTPUT
done
