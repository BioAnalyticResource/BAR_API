User Guide
==========

Gene Information
----------------

These endpoints can be used to retrieve gene annotations, aliases, probesets etc. For large input datasets, please use
POST request because POST request do not have URL length limit. Currently, the following species are available.

1. Arabidopsis

**POST /gene_information/gene_aliases/**

This end point provides gene aliases given a list of gene IDs for a species.

**GET /gene_information/gene_isoforms/{species}/{gene_id}**

This end point provides gene isoforms given a gene ID.

**POST /gene_information/gene_isoforms/**

This end point provides gene isoforms given a gene ID. This is the POST request that take a JSON object of species and
genes.






