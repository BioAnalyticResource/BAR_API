#!/bin/sh
# This script initialized the Travis environment

# To use locally, set up DB Password below
DB_USER="root"
DB_PASS=

# Load the data
echo "Welcome to the BAR API. Running init..."

if [ -n "$DB_PASS" ]; then
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/annotations_lookup.sql
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/single_cell.sql
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant2.sql
else
    mysql -u $DB_USER  < ./config/databases/annotations_lookup.sql
    mysql -u $DB_USER  < ./config/databases/single_cell.sql
    mysql -u $DB_USER  < ./config/databases/eplant2.sql
fi

echo "Data is now loaded. Preparing API config"
echo "Please manually edit config file!"

echo "Configuration file ready."
echo "----------- WARNING ----------"
echo "Do not forget to delete your password from the configuration files"
echo "if you are pushing to publicaly hosted Git repository."

