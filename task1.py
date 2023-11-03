import os
import sys
import csv

# this function makes basic changes except emails duplicates
def process_file():
    global email
    email = list()
    with open(sys.argv[1], 'r') as file1, open('accounts_tmp.csv', 'w', newline='') as file2:
        reader = csv.reader(file1)
        writer = csv.writer(file2)
        for r, row in enumerate(reader):
            if r == 0:
                writer.writerow(row)
                continue
            username = row[2].split()
            row[2] = f"{username[0].title()} {username[1].title()}"
            row[4] = f"{username[0][0].lower()}{username[1].lower()}@abc.com"
            email.append(row[4])
            writer.writerow(row)


# functions get list and return duplicates if any
def find_duplicates(list_with_dups: list):
    dups = list()
    uniq = set()
    for item in list_with_dups:
        if item in uniq:
            dups.append(item)
        else:
            uniq.add(item)
    return dups

# this function check email duplicate, if so location_ad added 
def fix_dups(dups_set: set):
    with open('accounts_tmp.csv', 'r') as file1, open('accounts_new.csv', 'w', newline='') as file2:
        reader = csv.reader(file1)
        writer = csv.writer(file2)
        for r, row in enumerate(reader):
            if r == 0:
                writer.writerow(row)
                continue
            if row[4] in dups_set:
                row[4] = f"{row[4].split('@')[0]}{row[1]}@abc.com"

            writer.writerow(row)

#run script
if __name__ == "__main__":
    process_file()
    fix_dups(set(find_duplicates(email)))
    os.remove('accounts_tmp.csv')
