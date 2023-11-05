#!/bin/bash
INPUT=$1
function header(){
  re='\[(.*?)\].*1..([0-9]+)'
  if [[ $line =~ $re ]]; then
    title="${BASH_REMATCH[1]}"
    test_num="${BASH_REMATCH[2]}"
  else
    echo "something wrong with header"
  fi
  echo $title $test_num
}

function body(){
  #echo $line
  re='^(ok|not ok).*\b([0-9]+) (.*),.*\b([0-9]+)ms'
  if [[ $line =~ $re ]]; then
    result="${BASH_REMATCH[1]}"
    num="${BASH_REMATCH[2]}"
    message="${BASH_REMATCH[3]}"
    time="${BASH_REMATCH[4]}"
  else
    echo "something wrong with body"
  fi
  echo "test# $num completed in $time""ms and result is $result because - $message "
}

function overall(){
  re='^([0-9]+).*,.*\b([0-9]+).*,.*\b([0-9]+.[0-9]+)%,.*\b([0-9]+)ms'
  if [[ $line =~ $re ]]; then
    success="${BASH_REMATCH[1]}"
    fails="${BASH_REMATCH[2]}"
    rates="${BASH_REMATCH[3]}"
    total_time="${BASH_REMATCH[4]}"
  else
    echo "something wrong with overall"
  fi
  echo "success: $success, fails: $fails, rate: $rates, time: $total_time"
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
