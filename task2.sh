#!/bin/bash

sed -n 's/.*\[ \([^]]*\) \].*/{ "testName": "\1", "tests": [/p' output.txt > output.json
sed -n 's/\(ok\|not ok\).*\b\([0-9]\+\) \(.*\),.*\b\([0-9]\+\)ms/{ "name": "\3", "status": "\1", "duration": "\4ms" },/p' output.txt >> output.json
sed -i '$s/,$//' output.json
sed -n 's/^\([0-9]\+\).*\b\([0-9]\+\).*\b\([0-9]\+\.[0-9]\+\)%,.*\b\([0-9]\+\)ms.*/], "summary": { "success": \1, "failed": \2, "rating": \3, "duration": "\4ms" } }/p' output.txt >> output.json
