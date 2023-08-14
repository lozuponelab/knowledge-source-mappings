# Environment Installation
```bash
mamba env create -f db_review.yml
```

# Generate the Reference Matrix Visualization
```bash
snakemake --cores 1
```
## Child Database Expansion
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

| Source DB    | Target DB | Edge Distance |
|--------------|-----------|---------------|
| WikiPathways | NCBIGene  | 1             |
| WikiPathways | ChEBI     | 1             |
| WikiPathways | HMDB      | 1             |
| WikiPathways | UniProt   | 2             |
| WikiPathways | PDB       | 2             |
| WikiPathways | OMIM      | 2             |
| WikiPathways | PubChem   | 2             |
| WikiPathways | GenBank   | 2             |

## Reference Matrix Visualization
We then use our expanded reference table to hierarchically cluster the Source Databases (plotted along the y-axis) based off edge distance to the child nodes.
![alt text](./plots/db_edge_matrix_children.png "Database Links with Children")


