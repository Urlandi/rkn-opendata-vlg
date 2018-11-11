echo "Name" > volgograd-isp-net.csv
./find-isp-net.sh $1 | grep -i ":os_name>" | sed -n -f clean-isp.sed | LC_COLLATE=C sort -bfu >> volgograd-isp-net.csv
