# Microbial Dysregulation of the 'Lung-Gut' Axis in High-Risk Bronchiectasis
---
This document illustrates the use of the codes to implement the methods described in the article "Microbial Dysregulation of the 'Lung-Gut' Axis in High-Risk Bronchiectasis". This document also contains additional/supplementary information and methods used in this manuscript. 

## Table of contents
1. [Supplementary Methods](#supplementary-methods)
2. [Pre requisites](#pre-requisities)
3. [Co-occurence analysis](#co-occurence-analysis)

## Supplementary Methods
The DNA were quantified by Qubit (Invitrogen), and quality checked by Nanodrop (Invitrogen). The forward and reverse primers used for 16S targeted amplicon sequencing are TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCTACGGGNGGCWGCAG and GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGACTACHVGGGTATCTAATCC, respectively. For mycobiome analysis the forward and reverse primers used for ITS targeted amplicon sequencing were ATGCCTGTTTGAGCGTC and CCTACCTGATTTGAGGTC, respectively. For shotgun metagenome, quality control, removal of human reads and estimation of taxonomic composition were performed as described in [https://www.nature.com/articles/s41591-021-01289-7](https://www.nature.com/articles/s41591-021-01289-7). Taxonomic call from the Kaiju classifier were further scrutinised by BLAST confirmatory analysis of raw sequence data performed by considering only species whose relative abundance is >1% in at-least 1 sample. A sub-sample of reads (assigned by kaiju) were randomly subjected to BLASTN analysis (using the megablast function and a specificed E-value of 10) against the corresponding database sequences for that species. Sequence similarity of ≥ 50% was as considered as a significant hit and were used for further analysis, while taxa failing to reach this cut off were excluded from analysis.

|                                            |                              |  Cluster 1 (N=31)  |  Cluster 2 (N=26)  | p-value  |
|:------------------------------------------:|:----------------------------:|:------------------:|:------------------:|:--------:|
|                Sex (female)                |                              |     25 (80.6%)     |     20 (76.9%)     |  0.731   |
|          Age, median (IQR) years           |                              | 65.0 (55.0, 75.0)  | 62.5 (54.2, 69.8)  |  0.202   |
|               Smoking status               |                              |                    |                    |   0.413  |
|                                            |            Never             |     20 (64.5%)     |     14 (53.8%)     |          |
|                                            |        Former/Active         |     11 (35.5%)     |     12 (46.2%)     |          |
|    Body mass index [Kg/m2], median (IQR)   |                              | 20.2 (19.0, 24.2)  | 21.6 (19.3, 25.8)  |  0.348   |
|          Reiff score, median (IQR)         |                              |   6.0 (4.0, 8.0)   |   4.0 (3.0, 5.0)   |   0.01   |
|             BSI, median (IQR)              |                              |  8.0 (6.0, 10.5)   |  7.0 (5.0, 10.0)   |   0.26   |
|            FACED, median (IQR)             |                              |   3.0 (2.0, 4.0)   |   2.0 (1.0, 3.0)   |  0.037   |
|                 Aetiology                  |                              |                    |                    |   0.34   |
|                                            |         Idiopathic           |     20 (64.5%)     |     18 (69.2%)     |          |
|                                            |      Immunodeficiency        |     4 (12.9%)      |     3 (11.5%)      |          |
|                                            | Primary ciliary dyskinesia   |     5 (16.1%)      |      0 (0.0%)      |          |
|                                            |       Post infective         |      1 (3.2%)      |      1 (3.8%)      |          |
|                                            |        NTM-infection         |      1 (3.2%)      |      1 (3.8%)      |          |
|                                            |           Other*             |      0 (0.0%)      |     3 (11.4%)      |          |
| Exacerbations previous year, median (IQR)  |                              |   3.0 (2.0, 4.0)   |   2.0 (2.0, 3.0)   |   0.14   |
|      >1 hospitalization previous year      |                              |     3 (10.0%)      |     5 (20.0%)      |  0.295   |
|                    mMRC                    |                              |                    |                    |  0.136   |
|                                            |              0               |     12 (38.7%)     |     12 (46.2%)     |          |
|                                            |              1               |     11 (35.5%)     |     12 (46.2%)     |          |
|                                            |              2               |      1 (3.2%)      |      2 (7.7%)      |          |
|                                            |              3               |     6 (19.4%)      |      0 (0.0%)      |          |
|                                            |              4               |      1 (3.2%)      |      0 (0.0%)      |          |
|        FEV1, median (IQR) %predicted       |                              | 71.0 (59.5, 88.5)  | 71.0 (65.8, 91.5)  |  0.558   |
|             Chronic infection              |                              |     18 (60.0%)     |     9 (37.5%)      |   0.1    |
|      Chronic infection P. aeruginosa       |                              |     13 (43.3%)     |     5 (20.8%)      |  0.081   |
|           Chronic Infection MSSA           |                              |      2 (6.7%)      |      2 (8.3%)      |  0.816   |
|      Chronic Infection H. Influenzae       |                              |     3 (10.0%)      |     3 (12.5%)      |  0.771   |
|      Chronic Infection S. pneumoniae       |                              |      1 (3.3%)      |      0 (0.0%)      |  0.367   |
|           Chronic Infection MRSA           |                              |      1 (3.3%)      |      0 (0.0%)      |  0.367   |
|      Chronic Infection S. maltophilia      |                              |      0 (0.0%)      |      2 (8.3%)      |  0.107   |
|          Other chronic infection           |                              |      9 (3.8%)      |      1 (4.2%)      |  0.259   |
|       Chronic Infection A. fumigatus       |                              |      3 (1.3%)      |      1 (4.2%)      |  0.259   |

**Table 1:** Clinical characteristics of patients according to the study clusters. Definition of abbreviations: BSI= Bronchiectasis severity index; MRSA= Methicillin-Resistant Staphylococcus Aureus; MSSA= Methicillin- sensitive Staphylococcus Aureus. Data are presented as median (interquartile range) or n (%).

---
## Pre requisites
This tutorial assumes you are on a linux based system. If you are an windows user, you might need to modify the commands from this tutorial. You will need the following softwares and packages to run the codes. 

1. [python3](https://www.python.org/downloads/)
	- [pandas](https://pandas.pydata.org/)
2. [R version 3.6.3](https://www.r-project.org/)
	- [mboost](https://cran.r-project.org/)
	- [boot](https://cran.r-project.org/)
	- [foreach](https://cran.r-project.org/)
	- [doParallel](https://cran.r-project.org/)

---
## Co-occurence analysis

```bash
├── clustering_result.csv
├── Co-occurence_analysis
│   ├── collate.py
│   └── GBLM_parallel1.R
├── Data
│   └── basespace-analyses
├── LICENSE
└── README.md
```
The above tree represents the directory structure of this repository. The Datasets used in this study can be found in the `` Data/ `` folder. 

The clustering output of the biomes from [https://integrative-microbiomics.ntu.edu.sg/](https://integrative-microbiomics.ntu.edu.sg/) is saved as `` clustering_result.csv ``

To run the co-occurrence analysis, follow the below steps:

1. `` ./collate.py clusternum output ``, where *clusternum* represents the cluster number (i.e. 1 or 2) and *output* represents the output file to save the collated file, which does pre-processing rendering it ameanable for further GBLM analysis. 
2. `` ./GBLM_parallel1.R input output ``, where *input* refers to the output of the 'collate' program. and *output* refers to the Adjacency matrix of the derived microbial association network using the GBLM algorithm. 


