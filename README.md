# Visualize the Reference Matrix
```bash
cd ./scripts/
python db_expansion.py

Rscript integrated_db_plotting.R
```
The `db_expansion.py` script generates the edge distance between a given database `i` and all child databases that it references. An example case for WikiPathways is given below.

```mermaid
---
title: Order example
---
erDiagram
    WikiPathways ||--o{ "NCBIGene" : "functional link"
    WikiPathways ||--o{ "ChEBI" : "chemical link"
    WikiPathways ||--o{ "HMDB" : "chemical link"
    HMDB ||--o{ "GenBank" : "taxonomic link"
    HMDB ||--o{ "ChEBI" : "chemical link"
    HMDB ||--o{ "PubChem" : "chemical link"
    HMDB ||--o{ "UniProt" : "functional link"
    HMDB ||--o{ "PDB" : "functional link"
    HMDB ||--o{ "OMIM" : "disease link" 
```

![alt text](db_viz_final.png "Database Links with Children")


