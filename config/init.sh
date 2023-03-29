#!/bin/sh
# This script initialized the GitHub environment

# To use locally, set up DB Password below
# The password below is for GitHub Actions. Please do not change.
DB_USER="root"
DB_PASS="root"

# Load the data
echo "Welcome to the BAR API. Running init!"

mysql -u $DB_USER -p$DB_PASS < ./config/databases/annotations_lookup.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/single_cell.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/embryo.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/shoot_apex.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/germination.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant2.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/summarization.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/poplar_nssnp.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/tomato_nssnp.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/soybean_nssnp.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_poplar.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_tomato.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_soybean.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_rice.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/tomato_sequence.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/rice_interactions.sql

echo "Data are now loaded. Preparing API config"
echo "Please manually edit config file!"

echo "Configuration file ready."
echo "----------- WARNING ----------"
echo "Do not forget to delete your password from the configuration files"
echo "if you are pushing to publicly hosted Git repository."
