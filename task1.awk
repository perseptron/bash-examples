BEGIN {
        FS = OFS = ","
        print("id,location_id,name,title,email,department") > "contacts_new_awk.csv"
}

NR > 1 {
        split(tolower($3), username, " ")
        mailbox = substr(username[1], 1, 1) username[2]
        a[mailbox] += 1
        sub(/./, toupper(substr(username[1], 1, 1)), username[1])
        sub(/./, toupper(substr(username[2], 1, 1)), username[2])
        print($1, $2, username[1] " " username[2], $4, mailbox "@abc.com", $6) > "contacts_new_awk.csv"
}

END {
        for (key in a) {
                if (a[key] > 1) {
                        print key
                }
        }
}

