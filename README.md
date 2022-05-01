# Microbial Dysregulation of the 'Lung-Gut' Axis in Bronchiectasis
---
This document illustrates the use of the codes to implement the methods described in the article "Microbial Dysregulation of the 'Lung-Gut' Axis in High-Risk Bronchiectasis". This document also contains additional/supplementary information and methods used in this manuscript. 

## Table of contents
1. [Pre requisites](#pre-requisities)
2. [Co-occurence analysis](#co-occurence-analysis)
    - [GBLM based network inference](#gblm-based-network-inference)
    - [Correlation based network inference](#correlation-based-network-inference)

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
###  Network inference, was performed in three ways dependent on sample size
- If sample size n > 20 = GBLM based network inference was implemented
- If sample size (n), 10 < n < 20 = GBLM network inference with bootstrap was implemented
- If sample size (n). n < 10 = correlation based ensemble (Spearman and Pearson correlation) network inference 
## GBLM based network inference

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
