#!/bin/env bash

cd /usr/local/src/rkn-opendata-vlg
git pull -q
./tools/fetch-data.sh lic 
git add volgograd.lic.csv volgograd-isp.md
git commit -q -m "Daily autoupdate"
git push -q -u origin master

cd ../elsv-v.ru
git pull -q
cp ../rkn-opendata-vlg/volgograd-isp.md ./content/dir/rkn
hugo --quiet
git add .
git commit -q -m "RKN licenses $(date +%F) update"
git push -q -u origin master

