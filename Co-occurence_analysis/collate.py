#!/usr/bin/env python3

'''
Run this code as 

./collate.py clusternum output

clusternum - The cluster number/label
output     - Output file name (as csv)
'''
import pandas
import sys

args=sys.argv

sput_bac=pandas.read_csv("./../Data/basespace-analyses/16S_Genus_Sputum_count.csv",index_col=0)
stool_bac=pandas.read_csv("./../Data/basespace-analyses/16S_Genus_Stool_count.csv",index_col=0)
sput_fun=pandas.read_csv("./../Data/basespace-analyses/ITS_Genus_Sputum_count.csv",index_col=0)
stool_fun=pandas.read_csv("./../Data/basespace-analyses/ITS_Genus_Stool_count.csv",index_col=0)

pat=pandas.read_csv("./../clustering_result.csv",index_col=0)

ind=sput_bac.index
sput_fun=sput_fun.loc[ind,:]
stool_bac=stool_bac.loc[ind,:]
stool_fun=stool_fun.loc[ind,:]
pat=pat.loc[ind,:]

def filter(data,abund,prev):
	data_norm=data.div(data.sum(axis=1), axis=0) #Re Normalize
	ind=(data_norm>=abund)
	sel=(ind.sum(axis=0)>=prev)
	data=data.loc[:,sel]
	data_norm=data.div(data.sum(axis=1), axis=0) #Re Normalize
	return(data_norm)

sput_bac=filter(sput_bac,0.01,5)
sput_fun=filter(sput_fun,0.01,5)
stool_bac=filter(stool_bac,0.01,5)
stool_fun=filter(stool_fun,0.01,5)

sput=pandas.merge(sput_bac,sput_fun,left_index=True,right_index=True)
sput=sput.div(sput.sum(axis=1), axis=0) #Normalize
stool=pandas.merge(stool_bac,stool_fun,left_index=True,right_index=True)
stool=stool.div(stool.sum(axis=1), axis=0) #Normalize

sput.columns=[i.strip()+"_lung" for i in sput.columns]
stool.columns=[i.strip()+"_gut" for i in stool.columns]
c0=pandas.concat([sput,stool],axis=1)
c0=c0.div(c0.sum(axis=1), axis=0) #Normalize

cluster=(pat["labels"]==int(args[1]))
c0=c0.loc[cluster,:]

c0.to_csv(args[2])
