import json
import re
import sys

cur_output = {}
tests = []


# divide text on logical units
def parseit():
    with open(sys.argv[1], 'r') as file:
        for line in file:
            match line[0:3]:
                case x if "[" in x[0:3]:
                    test_title(line)
                case x if "ok " in x[0:3] or "not" in x[0:3]:
                    test_detail(line)
                case x if "---" in x[0:3]:
                    hyphens(line)
                case _:
                    test_summary(line)

    with open('output.json', 'w') as file:
        json.dump(cur_output, file)


# get test_title
def test_title(row):
    test_name = row[1:row.index("]")].strip()
    cur_output["testName"] = test_name


# ignore hyphen line
def hyphens(row):
    pass


# get test detail
def test_detail(row):
    test_number_re = re.search(r'\d+\s', row)
    test_duration_re = re.search(r'\d+ms', row)
    if "not" in row[0:3]:
        status = False
    else:
        status = True
    name = row[test_number_re.end():test_duration_re.start()].strip().strip(",")
    duration = test_duration_re.group()
    test = {"name": name, "status": status, "duration": duration}
    tests.append(test)


# get test summary
def test_summary(row):
    res = row.split(", ")
    success = res[0][0:res[0].find(" ")].strip()
    failed = res[1][0:res[0].find(" ")].strip()
    rating = res[2][res[2].find("as") + 2:res[2].find("%")].strip()
    duration = res[3][res[3].find(" "):].strip()
    cur_output["tests"] = tests
    cur_output["summary"] = {"success": int(success), "failed": int(failed), "rating": float(rating), "duration": duration}


if __name__ == '__main__':
    parseit()
