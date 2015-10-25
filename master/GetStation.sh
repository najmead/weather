#!/bin/bash

TMP=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

mkdir ${TMP}

wget -P ${TMP} ftp://ftp.bom.gov.au/anon2/home/ncc/metadata/sitelists/stations.zip

unzip -d ${TMP} ${TMP}/stations.zip

create_sql="create table if not exists ${TMP} (line text);"

sqlite3 weather.db "${create_sql}"

stations_list="${TMP}/stations.txt"

import=".import ${stations_list} ${TMP}"

sqlite3 weather.db "${import}"
