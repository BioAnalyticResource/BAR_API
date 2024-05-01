User Guide
==========

Gene Information
----------------

These endpoints can be used to retrieve gene annotations, aliases, probesets etc. For large input datasets, please use
POST request because POST request do not have URL length limit. Currently, the following species are available.

1. Arabidopsis

**GET /gene_information/gene_alias/{species}/{gene_id}**

This end point provides gene alias given a gene ID

**POST /gene_information/gene_alias/**

This end point provides gene alias given a gene ID

**GET /gene_information/gene_isoforms/{species}/{gene_id}**

This end point provides gene isoforms given a gene ID.

**POST /gene_information/gene_isoforms/**

This end point provides gene isoforms given a gene ID. This is the POST request that take a JSON object of species and
genes.






