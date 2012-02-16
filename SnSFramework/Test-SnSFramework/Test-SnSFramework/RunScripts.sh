#!/bin/sh

# The purpose of this script is to prepare all necessary things before the scripts are ran.
# It is launched at compilation time

TEST_SQL_PATH="Test-SnSFramework/Test-SQLiteAccessor"
python ${PROJECT}/Resources/sqlite2model.py -s -p Test --id tid --output ${TEST_SQL_PATH} ${TEST_SQL_PATH}/test_sqlite.sql
 
