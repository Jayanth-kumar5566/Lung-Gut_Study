#======Analysis of Mouse Gut microbiome using correlation based network analysis =========
f<-read.csv("No.csv",row.names = 1) #Input files is given here

#======co-occurrence=======
data<-f/rowSums(f) #Normalisation


#Bootstrap
max_iter=100
rows=rownames(data)
boot_arr<-array(dim=c(dim(data)[2],dim(data)[2],max_iter))
for (i in 1:max_iter){
  t_x=sample(rows,replace = TRUE)
  sim=cor(data[t_x,],method="pearson")
  boot_arr[,,i]<-sim
}

#perm and renorm
max_iter=100
perm_arr<-array(dim=c(dim(data)[2],dim(data)[2],max_iter))
for (i in 1:max_iter){
  x<-apply(data,2,FUN =sample) #permutation
  x<-x/rowSums(x)#renormalization
  sim=cor(x,method="pearson")
  perm_arr[,,i]<-sim
}

#Converting NA to 0
boot_arr[is.na(boot_arr)]<-0
perm_arr[is.na(perm_arr)]<-0

p_val=array(dim=c(dim(sim)[1],dim(sim)[1]))
for (i in 1:dim(sim)[1]){
  for (j in 1:dim(sim)[1]){
    t=wilcox.test(perm_arr[i,j,],boot_arr[i,j,],alternative = "two.sided",paired = FALSE,exact = TRUE)
    p_val[i,j]<-t$p.value
  }
}

p<-p.adjust(p_val,method = "fdr")
dim(p)<-dim(p_val)

adj<-cor(data,method="pearson")
adj[abs(adj)<=0.3]<-0 #Drop all correlation values that are less than or equal to 0.3

rm(list=setdiff(ls(), c("data","adj","p")))


#=================Spearman================
#Bootstrap
max_iter=100
rows=rownames(data)
boot_arr<-array(dim=c(dim(data)[2],dim(data)[2],max_iter))
for (i in 1:max_iter){
  t_x=sample(rows,replace = TRUE)
  sim=cor(data[t_x,],method="spearman")
  boot_arr[,,i]<-sim
}

#perm and renorm
max_iter=100
perm_arr<-array(dim=c(dim(data)[2],dim(data)[2],max_iter))
for (i in 1:max_iter){
  x<-apply(data,2,FUN =sample) #permutation
  x<-x/rowSums(x)#renormalization
  sim=cor(x,method="spearman")
  perm_arr[,,i]<-sim
}

#Converting NA to 0
boot_arr[is.na(boot_arr)]<-0
perm_arr[is.na(perm_arr)]<-0

p_val=array(dim=c(dim(sim)[1],dim(sim)[1]))
for (i in 1:dim(sim)[1]){
  for (j in 1:dim(sim)[1]){
    t=wilcox.test(perm_arr[i,j,],boot_arr[i,j,],alternative = "two.sided",paired = FALSE,exact = TRUE)
    p_val[i,j]<-t$p.value
  }
}

p_spearman<-p.adjust(p_val,method = "fdr")
dim(p_spearman)<-dim(p_val)

adj_spearman<-cor(data,method="spearman")
adj_spearman[abs(adj_spearman)<=0.3]<-0


rm(list=setdiff(ls(), c("data","adj","p","adj_spearman","p_spearman")))

#==========Merging scores=========
scoring<-function(arr){
  m<-max(abs(arr),na.rm = TRUE)
  arr<-(arr/m)*100
  return(arr)
}

m_score=0
p_m=array(0,c(dim(p),2)) #2 methods

count=1
adjs=list(adj,adj_spearman)
pvals=list(p,p_spearman)
for (i in 1:2){
  a<-adjs[[i]]
  p<-pvals[[i]]
  p_m[,,count]<-as.matrix(p)
  m_score<-m_score+scoring(a)
  count=count+1
}

rm(list=setdiff(ls(), c("data","m_score","p_m")))

#=============Merging p-values=========
sime<-function(p){
  library(gMCP)
  x<-simes.test(p,weights=c(1,1))
  return(x)
}
p_f<-apply(p_m,c(1,2),sime)
p_f[p_f==0]<-NA
p_f[is.na(p_f)]<-2

m_score[p_f>=0.001]<-0

row.names(m_score)<-colnames(data)
colnames(m_score)<-colnames(data)

write.csv(m_score,"final_adj.csv") #Final output as adjacency matrix
