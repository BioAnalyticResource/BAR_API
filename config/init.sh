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
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_flower_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_flower_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_NIE_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_NIE_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_root_shahan_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_root_shahan_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_rosette_21d_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_rosette_21d_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_rosette_30d_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_rosette_30d_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seed_0d_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seed_0d_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seed_martin_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seed_martin_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seedling_12d_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seedling_12d_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seedling_3d_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seedling_3d_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seedling_6d_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_seedling_6d_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_shoot_zhang_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_shoot_zhang_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_silique_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_silique_lee_umap.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_stem_lee_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/arabidopsis_stem_lee_umap.sql
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
mysql -u $DB_USER -p$DB_PASS < ./config/databases/rice_OW_pseudobulk_dump.sql
mysql -u $DB_USER -p$DB_PASS < ./config/databases/rice_OW_umap.sql
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
mysql -u $DB_USER -p$DB_PASS < ./config/databases/gaia.sql

echo "Data are now loaded. Preparing API config"
echo "Please manually edit config file!"

echo "Configuration file ready."
echo "----------- WARNING ----------"
echo "Do not forget to delete your password from the configuration files"
echo "if you are pushing to publicly hosted Git repository."
