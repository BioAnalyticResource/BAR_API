#!/bin/sh
# This script initialized the GitHub environment

# To use locally, set up DB Password below
# The password below is for GitHub Actions. Please do not change.
DB_USER="root"
DB_PASS="root"

# Load the data
echo "Welcome to the BAR API. Running init!"

mysql -u $DB_USER -p$DB_PASS < ./config/databases/annotations_lookup.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_ecotypes.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arachis.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/cannabis.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/canola_nssnp.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/dna_damage.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/embryo.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant2.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_poplar.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_rice.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_soybean.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/eplant_tomato.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/fastpheno.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/germination.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/homologs_db.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/interactions_vincent_v2.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/kalanchoe.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/klepikova.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/llama3.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/phelipanche.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/physcomitrella_db.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/poplar_nssnp.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/rice_interactions.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/selaginella.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/shoot_apex.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/silique.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/single_cell.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/soybean_nssnp.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/strawberry.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/striga.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/tomato_nssnp.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/tomato_sequence.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/triphysaria.sql

echo "Data are now loaded. Preparing API config"
echo "Please manually edit config file!"

echo "Configuration file ready."
echo "----------- WARNING ----------"
echo "Do not forget to delete your password from the configuration files"
echo "if you are pushing to publicly hosted Git repository."
