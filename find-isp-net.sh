grep -B 3 -A 38 "region_code>34<" $1 | grep -B 18 -A 23 "is_tm>1<" | grep -A 41 -i "$2"