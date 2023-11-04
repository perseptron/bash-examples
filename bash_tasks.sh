
# Task
# Develop a script that takes a string as an argument and returns its reverse version, changing uppercase letters to lowercase and back

# Check
# ./loops1.sh "Hello World"
# DLROw OLLEh

#!/bin/bash
string=$1
inverted=${string~~}

l=${#inverted}

while [ $l -ge 0 ] ; do
        echo -n  "${inverted:l:1}"
        let l-=1
done
echo


# Task 2
# An unsorted list is passed to the script. Write a program that will output the sum of even numbers

# Check
# ./cond1.sh "1,2,3,4,5,6,7"
# 12

#!/bin/bash
IFS=','
a=($1)
sum=0
for i in ${a[@]}; do
  mod=$(($i%2))
  if [[ $mod -eq 0 ]]; then
        sum=$(($i+$sum))
  fi
done
echo  $sum


# Task 3
# Develop a script that takes the temperature value in Celsius OR Kelvins and returns the inverse value.
# The formula is pretty simple: C = K - 273; K = C + 273

# Check
# ./temp.sh 55C
# 328K
# ./temp.sh 122K
# -151C

#!/bin/bash
inpt=$1
val="${inpt::-1}"
unit="${inpt:(-1)}"

case "$unit" in
   C)
   echo $(($val+273))K
   ;;
   K)
   echo $(($val-273))C
   ;;
   *)
   echo "not such unit"
   ;;
esac


# Task 3
# Develop script that takes any string and calculate count of letters, numbers, symbols *!@#$%^&()_+ inside except whitespaces

# Check
# ./check_string.sh "Hello ! ** 564gfhf"
# Numbers: 3 Symbols: 3 Letters: 9

#!/bin/bash
set +o histexpand
string="$1"
numbers=0
chars=0
symb=0
other=0

while [[ i -lt ${#string} ]] ; do
  letter=${string:$i:1}
  #echo $letter
  case "$letter" in
    [0-9])
       numbers=$((numbers+1))
       ;;
    [a-zA-Z])
       chars=$(($chars+1))
       ;;
    [\!\@\#\$\%\^\&\*\(\)\_\+])
       symb=$(($symb+1))
       ;;
    *)
       other=$(($other+1))
       ;;
  esac
  i=$(($i+1))
done
echo Numbers: $numbers Symbols: $symb Letters: $chars


# Task 4
# Pow function
# Develop a pow() function that takes two arguments (a, b) and raises the first argument to the power of the second (a^b).

# Check
# pow 2 3
# 8

function pow() {
  echo $(($1 ** $2))
}

# Shortest string function
# Develop the shortest() function, which can take an unlimited number of arguments(strings) and output the shortest argument.

# Check
# shortest "This" "is" "Bash" "Functions" "Task"
# is

function shortest() {
 local OIFS=$IFS
 IFS=
 local all="$*"
 local min=${#all}
 IFS=$OIFS
   for param in "$@"; do
        if [[ "${#param}" -lt "$min" ]]; then
          min="${#param}"
        fi
   done
   for param in "$@"; do
        if [[ "${#param}" -eq "min" ]]; then
         echo $param
        fi
   done
}

# Log function
# Develop a print_log() function that takes a string as an argument and outputs the same string with the date at the beginning.
# In order for the automatic check to work, the string must be in this format: YEAR-MONTH-DAY HOUR:MINUTES

# print_log "Hello World!"
# [2022-05-10 13:04] Hello World!

function print_log() {
  echo $(date +"[%Y-%m-%d %H:%M]") $1
}


# Task 5
# Develop a script that takes number (count of needed folders up to 26) as an argument and create this folders in 
# current directory with next naming convention folder_<[a-z]>.

# Check
# ./array.sh 5
# 5 folders created:
# folder_a, folder_b, folder_c, folder_c, folder_d

#!/bin/bash
ind=({a..z})
for ((i=0; i < $1; i++)); do
   mkdir folder_${ind[i]}
done


# The GAME

#!/bin/bash
echo -e "\n NumberJack \n"
ch=0
while [ "$ch" -ne 3 ]; do
    echo  "  
         PLAY : Hit 1 and enter.
         HELP : Hit 2 and enter.
         EXIT : Hit 3 and enter.
         "
    read -p -r "Enter your choice : " ch
    if [ "$ch" -eq 1 ];then
    x=0 ;c=0 ;p=0
    read -p -r "Enter any number between 0 and 9 : " n
    while [ $c -eq 0 ];
    do
        x=11; r=$(shuf -i 0-9 -n 10)
        echo "${r[@]}"; for i in {1..10}; do
            a[i]=$i
        done
        echo "${a[@]}"
        read -t 5 -p -r "Enter the index of your number : " x
    if [[ $? -gt 128 ]]; then
    c=1
    break
    fi
if [ "${r[$($x)-1]}" -eq "$n" ];then
            echo "Great"
    (p=p+1)
        else
            c=1
            break
        fi
    done
    elif [ "$ch" -eq 2 ];then
        echo "HELP: INSTRUCTIONS TO PLAY THE GAME. "
else
        break
fi
if [ "$c" -eq 1 ];then
            echo -e "\nGAME OVER\n"
            echo "You scored $p points"
fi
        done


# Task 6
# With given passwd file do following:
# a. Create copy of passwd file to passwd_new. ❗ Do all modifications on passwd_new file
# b. Change shell for user saned from /usr/sbin/nologin to /bin/bash using AWK
# c. Change shell for user avahi from /usr/sbin/nologin to /bin/bash using SED
# d. Save only 1-st 3-th 5-th 7-th columns of each string based on : delimiter
# e. Remove all lines from file containing word daemon
# f. Change shell for all users with even UID to /bin/zsh

# passwd_new shouldn't has new line at the end of file

#!/bin/bash
awk -F: -v user="saned" -v shell="/bin/bash" '{ if ($1 == user) $7 = shell; print }' OFS=: passwd > passwd_new
sed -i '/avahi/s/\/usr\/sbin\/nologin/\/bin\/bash/g' passwd_new
awk -F: '{print $1, $3, $5, $7}' OFS=: passwd_new > passwd_tmp
sed -i '/daemon/d' passwd_tmp
awk -F: '($2 % 2 == 0) { $4 = "/bin/zsh" } { print }' OFS=: passwd_tmp > passwd_new
sed -i '/^$/d' passwd_new
perl -i -pe "chomp if eof" passwd_new
rm passwd_tmp 



# Task FINALE

# Story
# Your college has developed a script to upload files from terminal to https://free.keep.sh Unfourtenetly, he has left the company. The script isn't working now. Your team asked for a new functionality to download uploaded files.
# Create a script which will upload and download file from transfer.sh. Add a description in the beggining of the script and comment the code. Please also follow the Bash Style Guide.

# Checks
# Upload
# Upload should support uploading multiple files, as in example:

# user@laptop:~$ ./transfer.sh test.txt test2.txt
# Uploading test.txt
# ...
# Transfer File URL: https://free.keep.sh/Mij6ca/test.txt
# Uploading test2.txt
# ...
# Transfer File URL: https://free.keep.sh/Msfddf/test2.txt

# Download
# Add a download flag -d which would download single file from the transfer.sh to the specified directory:
# Progress bar should be in output. (Hint: check flags)

# ⚠ Create a function for downloading files: singleDowload and for returning the result: printDownloadResponse
# user@laptop:~$ ls 
# test test.txt transfer.sh

# user@laptop:~$ ./transfer.sh -d ./test Mij6ca test.txt
# Downloading test.txt
# ...
# Success!

# Help
# Add a help flag -h to output the help message with decription, how to work with the script:

# user@laptop:~$ ./transfer.sh -h
# Description: Bash tool to transfer files from the command line.
# Usage:
#   -d  ...
#   -h  Show the help ... 
#   -v  Get the tool version
# Examples:
# <Write a couple of examples, how to use your tool>
# ./transfer.sh test.txt ...

# Version
# Add a flag to get your script version:

# user@laptop:~$ ./transfer.sh -v
# 0.0.1


#!/bin/bash
#########################################################
# Upload and download files to/from https://free.keep.sh/
# #######################################################

CURRENT_VERSION="0.0.1"

########################################################
# upload file obtained as parameter $1 to remote server
########################################################
httpSingleUpload()
{
  response=$(curl --upload-file "$1" "https://free.keep.sh/$2") ||  { echo "Failure!" ; return 1; }
}

########################################################
# download file obtained as a parameter $3 from remote
# folder $2 and saved into localdirectory $1
########################################################
httpSingleDownload(){
 response=$(curl -L -# "https://free.keep.sh/$2/$3" > "$1"/"$3") ||  { echo "Failure!" ; return 1; }
 echo "$response"
}

#######################################################
# getting response from remote server after upload
#######################################################
printUploadResponse()
{
#fileID=$(echo "$response" | cut -d "/" -f 4)
cat <<EOF
Transfer File URL: $response
EOF
}

#######################################################
# checking if file exists after download request
#######################################################
printDownloadResponse()
{
  if [[ -f "$1"/"$2" ]]; then
    echo "Sucess!"
  else
    echo "Download fail!"
  fi
}

######################################################
# checking if file exists before upload
######################################################
singleUpload()
{
  filePath="${1/~/$HOME}"
  if ! [[ -f "$filePath" ]]; then
    echo "Error: invalid file path"
    return 1
  fi
  tempFileName=$(echo "$1" | sed "s/.*\///")
  echo "Uploading $tempFileName"
  httpSingleUpload "$filePath" "$tempFileName"
}

########################################################
# preparing directory before download
########################################################
singleDownload()
{
  if ! [[ -d $1 ]]; then
    mkdir -p "$1" || { echo "error creating directory" ; exit 1; }
  fi
  echo "Downloading $3"
  httpSingleDownload "$1" "$2" "$3"
}

case "$1" in
  "-h" | "--help" | "" )
    echo "Description: Bash tool to transfer files from the command line."
    echo "Usage:"
    echo "  -d Download file"
    echo "  -h Show the help"
    echo "  -v Get the tool version"
    echo "Examples:"
    echo "For upload:"
    echo "./transfer.sh <filename1> <filename2> <filename3> ..."
    echo "For download:"
    echo "./transfer.sh -d <local dir> <remote dir> <filename>"
    ;;
  "-v" )
    echo "$CURRENT_VERSION"
    ;;
  "-d" )
    singleDownload "$2" "$3" "$4"
    printDownloadResponse "$2" "$4"
    ;;
  * )
    for param in "$@"; do
      singleUpload "$param" || continue
      printUploadResponse
    done
    ;;
esac


# Task 1 
# Write simple script that reads some log file apache_logs and writes into the file not_found.txt information about address, 
# HTTP method and path from all requests where a 404 status code was thrown.
# Input data looks like:
# 91.177.205.119 - - [17/May/2015:10:05:32 +0000] "GET /favicon.ico HTTP/1.1" 200 3638 "-" "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Win64; x64; Trident/6.0)"
# 66.249.73.185 - - [17/May/2015:10:05:22 +0000] "GET /doc/index.html?org/elasticsearch/action/search/SearchResponse.html HTTP/1.1" 404 294 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
# 207.241.237.228 - - [17/May/2015:10:05:40 +0000] "GET /blog/tags/defcon HTTP/1.0" 200 24142 "http://www.semicomplete.com/blog/tags/C" "Mozilla/5.0 (compatible; archive.org_bot +http://www.archive.org/details/archive.org_bot)"

# Example of file apache_logs can be found here

# The result should be something like this:

# 38.99.236.50 “GET /files/logstash/logstash-1.3.2-monolithic.jar


#!/bin/bash

while read -r line; do
  split_line=($line)
  if (( ${split_line[8]} == "404" )); then
    echo  ${split_line[0]} ${split_line[5]} ${split_line[6]} >>  not_found.txt
  fi
done <apache_logs

# Olexiy Boshchenko one line solution
#!/bin/bash 
grep -w "404" apache_logs | awk '{print$1, $6, $67}' > not_found.txt 


# Task 2
# There is a directory called somefolder that contains various subdirectories and files. Write script that changes permissions so that:
# for each subdirectory, except for the sharedfolder folder, only the owner (and root) of a file can remove the file within that subdirectory
# the subdirectory with name sharedfolder files that you create in that subdirectory are owned by the group owning the subdirectory

#!/bin/bash
path="somefolder/"
find "$path" -type d ! -name $path ! -name "sharedfolder" | while read -r file; do
chmod 1755 $file
done

find "$path" -type d -name "sharedfolder" | while read -r file; do
chmod 2755 $file
done

# Task 3
# Task on Linux Processes
# Using known Linux commands you should increase the value of CPU Load Average above 80%. Write your solution in the processes.sh file.

#!/bin/bash
echo {1..10000}{1..10000}

# Task 4: List of Processes in Linux
# Write a bash script list_processes.sh that uses the ps command to list all currently running processes, 
# including their respective command names, process IDs (PIDs), and parent process IDs (PPIDs).

#!/bin/bash
ps -eo args=CMD,pid,ppid


# Task 4 
# Given a file to process as a single parameter (example of the Apache log file you can get here)
# You need to calculate the size downloaded to each ip address and print the report sorted by download size and by ip 
# (for equal size). First print the number of unique ips and the total downloaded size (in bytes and in human readable iec-i format). 
# For printing the report use 15 letters to print first column (ips) left aligned then single space and then at least 9 symbols 
# aligned right for the second column (sizes).
# Input data look like these (see common log format for field description):

# 83.149.9.216 - - [17/May/2015:10:05:03 +0000] "GET /presentations/logstash-monitorama-2013/images/kibana-search.png HTTP/1.1" 200 203023 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
# 83.149.9.216 - - [17/May/2015:10:05:43 +0000] "GET /presentations/logstash-monitorama-2013/images/kibana-dashboard3.png HTTP/1.1" 200 171717 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
# 83.149.9.216 - - [17/May/2015:10:05:47 +0000] "GET /presentations/logstash-monitorama-2013/plugin/highlight/highlight.js HTTP/1.1" 200 26185 "http://semicomplete.com/presentations/logstash-monitorama-2013/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"

#!/bin/bash
#get Apache log file as a parameter
log_file=$1

#declare associative array where ip and bytes downloaded will be stored
declare -A  stat

#declare total bytes variable
total=0
function to_hr() {
    local int_part=${1%.*}
    pow=${2:-0}
    if [[ ${#int_part} -gt 3 ]]; then
        pow=$(( pow+1 ))
        val=$(echo "scale=1; $1 / 1024" | bc)
        to_hr $val $pow
    else
        if ! [[ $1 == 0 ]]; then
          res=$(echo "$1 + 0.1" | bc)
        else
          res=0.0
        fi
        case "$pow" in
           0)
             echo "$res"B
             ;;
           1)
             echo "$res"KiB
             ;;
           2)
             echo "$res"MiB
             ;;
           3)
             echo "$res"GiB
             ;;
           4)
             echo "$res"TiB
             ;;
           *)
             echo "too much"
             ;;
        esac
    fi
}
#loop through lines and make calculations
while read -r line; do
      split_line=($line)
      #sqip empty lines
      #if [[ ${#split_line} -eq 0 ]]; then
      #   continue
      #fi
      ip=${split_line[0]}
      #if [[ ${#ip} -le 6 ]]; then
      #   continue
      #fi
      traffic=${split_line[9]}
      if [[ ${traffic} == "-" ||  ${traffic} == " " ]]; then
         traffic=0
      fi
      if ! [[ $traffic =~ ^[0-9]+$ ]] ; then
         #echo "bad traffic: $traffic"
         continue
      fi
      traff_inc=${stat[$ip]}
      stat[$ip]=$((traff_inc+traffic))
      total=$((total+traffic))
done <<< $( cat $log_file )

echo "There are ${#stat[@]} unique ips"
totalhr=$(to_hr $total)
echo "Total downloaded: $total ($totalhr)"
for ip in "${!stat[@]}"; do
   printf '%-15s %9d\n' "$ip" "${stat[$ip]}"
done | sort -rn -k2 -k1


# Task my
# Uppercase every first letter of every word in the sentence using only parameter expansion

#!/bin/bash
# Sample variable
var="this is a sample sentence"

# Split the variable into words
words=($var)

# Uppercase the first letter of each word using parameter expansion
new_var="${words[@]^}"

# Join the words back into a single string
new_var="${new_var[*]}"

# Print the result
echo "$new_var"