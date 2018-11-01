echo "Name,Licence,Date Reg,License Type,Date Start, Date End" > volgograd-isp-lic.csv
./find-isp-lic.sh $1 | sed -n -f clean-isp.sed | sed -n -f concat-isp-lic.sed | LC_COLLATE=C sort -bfu >> volgograd-isp-lic.csv
