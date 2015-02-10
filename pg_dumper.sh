#!/bin/bash

export_host='192.168.0.77'
export_user='username'
export_db='dbname'
export_port='5432'
export_passwd='passwd'

local_host='localhost'
local_user='postgres'
local_db='dbname'

main_db='db.sql'

# List schema
export=(
	'schema_1'
	'schema_2'
	'schema_3'
)

if [ -f "schema_"$export_db".sql" ]; then
	rm "schema_"$export_db".sql"
fi

PGPASSWORD=$export_passwd pg_dump -h $export_host -p $export_port -U $export_user -s $export_db > "schema_"$export_db.sql;
echo "";
echo "schema_"$export_db".sql ................DONE";

cats='schema_'$export_db'.sql';
for n in "${export[@]}"; do
	if [ -f ${n}".sql" ]; then
		rm ${n}".sql"
	fi

	PGPASSWORD=$export_passwd pg_dump -a -h $export_host -p $export_port -U $export_user -d $export_db -n ${n} > ${n}.sql;
	cats=$cats" ${n}.sql";
	echo "${n}.sql ...........................DONE";
done
if [ -f $main_db ]; then
	rm $main_db
fi
cat $cats > $main_db;
echo "";
echo "$main_db ................DONE";

rm $cats;

sudo -u $local_user psql -h $local_host -U $local_user -d $local_db -f $main_db;

rm $main_db;

echo "";
echo "Finished";