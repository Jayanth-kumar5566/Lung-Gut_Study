#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#Reading the dataset
data=read.csv(args[1],row.names = 1)*100

GBLM<-function(data){
# data<-t(data)
# print("started")
library(mboost)
# For c1_data
cr_mat=cor(data,method = "spearman") #Compute Spearman Correlation
cr_mat[is.na(cr_mat)]<-0  # Assign 0 to NA values(NA due to zero STD)

r2<-function(model,col=i,data=data){
  sse=sum((predict(model,data)-data[[col]])^2)
  tss=sum((data[[col]]-mean(data[[col]]))^2)
  error=1-(sse/tss)
  return(error)
}


run<-function(i,cr_mat,data){
  library(mboost)
  
  #Adjacency matrix and p-value matrix creation
    m=matrix(0,ncol=dim(cr_mat)[1],nrow=dim(cr_mat)[2])
    p_m=matrix(2,ncol=dim(cr_mat)[1],nrow=dim(cr_mat)[2])
    m<-data.frame(m,row.names = colnames(data))
    p_m<-data.frame(p_m,row.names = colnames(data))
    colnames(m)<-colnames(data)
    colnames(p_m)<-colnames(data)

  x_nam=rownames(cr_mat)[i]
  ind1=abs(cr_mat[i,]) > 0 & abs(cr_mat[i,]) != 1
  cool=which(ind1, arr.ind = T)
  y_nam=rownames(as.data.frame(cool)) 
  if(identical(y_nam,character(0)) == TRUE){
  return(matrix(NA,1,dim(cr_mat)[2],dimnames=list(x_nam,colnames(data))))
  }
  # print(x_nam) #Row name
  #Formula
  form=as.formula(paste(x_nam,paste(y_nam,collapse = "+"),sep="~"))
  
  #LOOP and take average over 100 iterations
  booot_weight=matrix(NA,ncol=dim(cr_mat)[1],nrow=100)
  colnames(booot_weight)<-colnames(data)
  for (boot_iter in 1:100){
  #GLMBoosting and Model Tuning, Depends on randomness
  model1<-glmboost(form,data=as.data.frame(data),family = Gaussian(),
                   center=TRUE,control = boost_control(mstop=200,nu=0.05,trace=FALSE))
  #Induces randomness, can loop and take the nearest average integer
  f<-cv(model.weights(model1),type="kfold",B=10) # ==== error===============
  cvm<-cvrisk(model1,folds=f,mc.cores=16)
  opt_m<-mstop(cvm)
  if(opt_m==0){opt_m=1}
  #Choosing the optimal model
  model1[opt_m]
  error=r2(model1,col=i,data=as.data.frame(data))
  if (error<0.5){next}
  
  wghts<-coef(model1,which="")
  x<-t(as.data.frame(wghts[-1]))
  row.names(x)<-x_nam
  for(cl in colnames(x)){
    booot_weight[boot_iter,cl]<-x[x_nam,cl]
  }
  }
  nan_mean<-function(x){median(x,na.rm = TRUE)}
  boot_x<-as.matrix(apply(booot_weight,2,nan_mean))
  
    #Appending the coefficient matrix to adjacency matrix
    for(cls in row.names(boot_x)){
      m[x_nam,cls]<-boot_x[cls,1]
    }
  print(m[1,])
  if (all(is.na(boot_x))){rm(boot_x);return(matrix(NA,1,dim(cr_mat)[2],dimnames=list(x_nam,colnames(data))))}
  rm(boot_x)
  #Bootstrap distribution
  #------------Using boot-----------------  
  # print("Bootstrapping")
  library(boot)
  boot.stat<-function(data,indices,m_stop,form,x_nam){
    data<-data[indices,]
    mod<-glmboost(form,data=as.data.frame(data),family = Gaussian(),
                  center=FALSE,control = boost_control(mstop=m_stop,nu=0.05,trace=FALSE))
    wghts<-coef(mod,which="")
    x<-t(as.data.frame(wghts[-1]))
    row.names(x)<-x_nam
    return(x)
  }
  
  model.boot<-boot(data,boot.stat,100,m_stop=opt_m,form=form,x_nam=x_nam)
  #-----------Permutation with renormalization-------------
  # print("Permuting")
  #copy of the data
  data_p=as.data.frame(data)
  out_comb<-x
  #permutation
  counter=0
  while (counter<100){
    data_p[[x_nam]]<-sample(data_p[[x_nam]])
    #renormalization
    data_p=(data_p/rowSums(data_p))*100
    out<-boot.stat(data_p,indices = 1:dim(data)[1],m_stop=opt_m,form=form,x_nam=x_nam)
    out_comb=rbind(out_comb,out)
    counter = counter + 1
  }
  out_comb<-out_comb[-1,]
  #Comparing two distributions
  p_test<-c()
  for (i in 1:dim(out_comb)[2]){
    p=wilcox.test(model.boot$t[,i],out_comb[,i],alternative = "two.sided",paired = FALSE)$p.value
    p_test<-c(p_test,p)
  }
  #correction of multiple comparision
  p_test<-p.adjust(p_test,method = "fdr")
  for (i in 1:dim(out_comb)[2]){
  p_m[x_nam,colnames(out_comb)[i]]<-p_test[i]
}

  return(list(m,p_m))
}

library(foreach)
library(doParallel)
cores=detectCores()
cl <- makeCluster(cores[1])
registerDoParallel(cl)

finalMatrix <- foreach(i=1:dim(data)[2], .combine=rbind) %dopar% {
   res<-run(i,cr_mat,data)
   if (sum(is.na(res))){m<-res;m[is.na(m)] <- 0}
   else{
   m<-res[[1]][i,] #adjaceny matrix
   p_m<-res[[2]][i,] #p-value matrix
   ind<-(p_m>0.001) #p-value is non-significant
   m[ind]<-0 #make those edges 0
   }
       
   m
  }

stopCluster(cl)
# 
#for (i in 1:dim(data)[2]){
#res<-run(i,cr_mat,data)
#m<-res[[1]][i,] #adjaceny matrix
#p_m<-res[[2]][i,] #p-value matrix
#ind<-(p_m>0.001) #p-value is non-significant
#m[ind]<-0 #make those edges 0

#return(as.matrix(m))
#}
return(as.matrix(finalMatrix))
}

out_final<-GBLM(data)
write.csv(out_final,args[2])