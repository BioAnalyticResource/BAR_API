#!/bin/sh
# This script initialized the Travis environment

# To use locally, set up DB Password below
# The password below is for GitHub Actions. Please do no change.
DB_USER="root"
DB_PASS="root"

# Load the data
echo "Welcome to the BAR API. Running init..."

if [ -n "$DB_PASS" ]; then
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/annotations_lookup.sql
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/single_cell.sql
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant2.sql
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/summarization.sql
    mysql -u $DB_USER -p$DB_PASS < ./config/databases/poplar_nssnp.sql
else
    mysql -u $DB_USER  < ./config/databases/annotations_lookup.sql
    mysql -u $DB_USER  < ./config/databases/single_cell.sql
    mysql -u $DB_USER  < ./config/databases/eplant2.sql
    mysql -u $DB_USER  < ./config/databases/summarization.sql
    mysql -u $DB_USER  < ./config/databases/poplar_nssnp.sql
fi

echo "Data are now loaded. Preparing API config"
echo "Please manually edit config file!"

echo "Configuration file ready."
echo "----------- WARNING ----------"
echo "Do not forget to delete your password from the configuration files"
echo "if you are pushing to publicaly hosted Git repository."

