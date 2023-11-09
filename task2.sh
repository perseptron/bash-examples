#!/bin/bash
INPUT=$1
OUTPUT=${1%.*}".json"
sed -n 's/.*\[ \([^]]*\) \].*/{ "testName": "\1", "tests": [/p' $INPUT > $OUTPUT
sed -n 's/\(ok\|not ok\).*\b\([0-9]\+\) \(.*\),.*\b\([0-9]\+\)ms/{ "name": "\3", "status": "\1", "duration": "\4ms" },/p' $INPUT >> $OUTPUT
sed -i '$s/,$//' $OUTPUT
sed -n 's/^\([0-9]\+\).*, \([0-9]\+\).*,.* \([0-9]\+\(\.[0-9]\+\)\?\)%,.* \([0-9]\+\)ms.*/], "summary": { "success": \1, "failed": \2, "rating": \3, "duration": "\5ms" } }/p' $INPUT >> $OUTPUT
sed -i 's/not ok/false/g; s/ok/true/g' $OUTPUT
