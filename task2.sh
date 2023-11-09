#!/bin/bash
INPUT=$1
OUTPUT=${1%.*}".json"
function header(){
  re='\[ (.*?) \].*1..([0-9]+)'  # [ Asserts Samples ], 1..7 tests
  if [[ $line =~ $re ]]; then
    title="${BASH_REMATCH[1]}"
    test_num="${BASH_REMATCH[2]}"
  else
    echo "something wrong with header"
  fi
}

function body(){
  re='^(ok|not ok).*\b([0-9]+) (.*),.*\b([0-9]+)ms'  # ok  3  expecting command fails (the same as above, bats way), 23ms
  if [[ $line =~ $re ]]; then
    num+=("${BASH_REMATCH[2]}")
    message+=("${BASH_REMATCH[3]}")
    time+=("${BASH_REMATCH[4]}")
    if [[ "${BASH_REMATCH[1]}" =~ "not" ]]; then
      result+=("false")
    else
      result+=("true")
    fi
  else
    echo "something wrong with body"
  fi
}

function overall(){
 re='([0-9]+).*, ([0-9]+).*,.* ([0-9]+(\.[0-9]+)?)%,.* ([0-9]+)ms'  # 5 (of 7) tests passed, 2 tests failed, rated as 71.43%, spent 136ms
 if [[ $line =~ $re ]]; then
    success="${BASH_REMATCH[1]}"
    fails="${BASH_REMATCH[2]}"
    rates="${BASH_REMATCH[3]}"
    total_time="${BASH_REMATCH[5]}"
  else
    echo "something wrong with overall"
  fi
  json_compose
}

function json_compose(){
  echo "{\"testName\": \"$title\", \"tests\": [" > $OUTPUT
  for (( i=0; i < "${#num[@]}"; i++ )) ;do
    echo "{ \"name\": \"${message[$i]}\", \"status\": \"${result[$i]}\", \"duration\": \"${time[$i]}ms\" }" >> $OUTPUT
    if (( $i != ${#num[@]} -1 ));then
       echo "," >> $OUTPUT
    fi
  done
  echo "], \"summary\": {\"success\": $success, \"failed\": $fails, \"rating\": $rates, \"duration\": \"$total_time""ms\" } }" >> $OUTPUT
  unset message
  unset result
  unset time
  unset num
}

while read -r line; do
  if [[ "${line:0:1}" == "[" ]]; then
    header
  fi
  if [[ "${line:0:6}" =~ "ok" ]]; then
    body
  fi
  if [[ "${line:0:30}" =~ "tests passed" ]]; then
    overall
  fi
done < <(grep "" $INPUT) #to read last line because file doesn't end with new line
