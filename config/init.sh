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
else
    mysql -u $DB_USER  < ./config/databases/annotations_lookup.sql
    mysql -u $DB_USER  < ./config/databases/single_cell.sql
fi

echo "Data is now loaded. Preparing API config"
echo "Please manually edit config file!"

# Currently not working on all systems. Manually edit files
#sed -i '' -e "s/DB_USER/$DB_USER/g" ./config/BAR_API.cfg
#sed -i '' -e "s/DB_PASS/$DB_PASS/g" ./config/BAR_API.cfg

echo "Configuration file ready."
echo "----------- WARNING ----------"
echo "Do not forget to delete your password from the configdduration files"
echo "if you are pushing to publicaly hosted Git repository."

