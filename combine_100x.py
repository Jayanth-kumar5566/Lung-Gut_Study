import pandas
import numpy
import matplotlib.pyplot as plt

tmp=pandas.read_csv("Yes.csv",index_col=0)#Yes.csv is the input file
mat=numpy.zeros((tmp.shape[1],tmp.shape[1]))

for i in range(1,101): #100 range#
    fname="Yes_"+str(i)+".csv"# Name of output files
    df=pandas.read_csv(fname,index_col=0)
    df_nz=(df!=0).values.astype('int')
    mat += df_nz


mat_df=pandas.DataFrame(mat,index=df.index,columns=df.columns)
'''
mat_df.to_csv("compiled-C0-original.csv")

'''
fmat=numpy.zeros((tmp.shape[1],tmp.shape[1],100))

for i in range(1,101):
    fname="Yes_"+str(i)+".csv"
    df=pandas.read_csv(fname,index_col=0)
    fmat[:,:,i-1]= df.values

def median(x):
    if x.sum()==0:
        return(0)
    else:
        y=x[x!=0]
        z=numpy.median(y)
        return(z)

median_mat=numpy.zeros((tmp.shape[1],tmp.shape[1]))

for i in range(tmp.shape[1]):
    for j in range(tmp.shape[1]):
        median_mat[i,j]=median(fmat[i,j,:])

#==========Create cut-off based file=========

def cut_off(median_mat,cutoff,mat,df):
    median_mat[mat<cutoff]=0
    median_mat=pandas.DataFrame(median_mat,columns=df.columns,index=df.index)
    return(median_mat)


cut_off(median_mat,50,mat,df).to_csv("cut_off_No_50.csv") #Collated final adjacency matrix based on 100x GBLM
