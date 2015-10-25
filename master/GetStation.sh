#!/bin/bash

DB="../weather.db"
TMP=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 32 | head -n 1)

echo "Check that database actually exists"
if [ ! -e ${DB} ];
then
	echo 'Cannot find database'
	exit 0;
fi

echo "Check that station table exists"
station_exists=`sqlite3 ${DB} "select exists (select * from sqlite_master where type='table' and name='station');"`
if [ $station_exists -eq 0 ];
then
	echo "Cannot find table"
	exit 0;
fi

echo "Create a temporary working space, and download data"
mkdir ${TMP}
wget -P ${TMP} ftp://ftp.bom.gov.au/anon2/home/ncc/metadata/sitelists/stations.zip
unzip -d ${TMP} ${TMP}/stations.zip
stations_list="${TMP}/stations.txt"

echo "Create a temporary holding space in sqlite for the data"
create_sql="create table if not exists ${TMP} (line text);"
sqlite3 ${DB} "${create_sql}"
import=".import ${stations_list} ${TMP}"
sqlite3 ${DB} "${import}"

echo "Truncate existing table"
delete="delete  from station;"
sqlite3 ${DB} "${delete}"

echo "Copy load sequence, customise and then run"
cp LoadStation.sql ${TMP}/LoadStation.sql
sed -i s#\<\<TABLE\>\>#${TMP}# ${TMP}/LoadStation.sql
sqlite3 ${DB} < "${TMP}/LoadStation.sql"

echo "Cleanup"
rm -rf ${TMP}
delete="drop table ${TMP};"
sqlite3 ${DB} "${delete}"
