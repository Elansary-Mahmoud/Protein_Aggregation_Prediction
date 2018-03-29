rm(list=ls(all=TRUE)) 
library('kknn')
library('nnet')
library('RODBC')
library('MASS')
library('faraway')
library('e1071')
library('brglm')
library('rpart')
library('randomForest')
library('ROCR')


tune_parameters <- function(Data_Set)
{
		n = nrow(Data_Set)
		K = 10
		taille = n%/%K
		set.seed(5)
		alea = runif(n)
		rang = rank(alea)
		bloc = (rang-1)%/%taille + 1
		bloc = as.factor(bloc)
		all.mc.kknn=matrix(0, 2, 2)
		Paramaters_arr= array(0, c(1,20))
		K=11;
		for(parameter in 1:20)
		{
			for(fold in 1:K)
			{
				Data_Set.kknn <- kknn(Data_Set$Aggregate[bloc !=fold] ~ ., Data_Set[bloc !=fold,2:length(Data_Set)], Data_Set[bloc ==fold,2:length(Data_Set)], k = parameter, distance = 1,kernel = "triangular")
				pred.kknn <- fitted(Data_Set.kknn)
				mc.kknn = table(Data_Set$Aggregate[bloc ==fold], pred.kknn)
				all.mc.kknn = all.mc.kknn + mc.kknn
			}
		Results = Accuracy(all.mc.kknn)
		Paramaters_arr[,parameter] = as.double(Results[8])
	}
	max_par = 0;
	max = 0;
	for(parameter in 1:20)
	{
		if(Paramaters_arr[,parameter] >= max)
		{
		max = Paramaters_arr[,parameter]
		max_par = parameter
		}
	}

	output<-list(max_par,max,Paramaters_arr)
	names(output) <- c("max_par","max","Paramaters_arr")
	return(output)
}

myfun <- function(train,test)
{ 
	
all.mc.tree=matrix(0, 2, 2)
all.mc.svm=matrix(0, 2, 2)
all.mc.brglm=matrix(0, 2, 2)
all.mc.lda=matrix(0, 2, 2)
all.mc.kknn=matrix(0, 2, 2)
all.mc.nn=matrix(0, 2, 2)
all.mc.rf=matrix(0, 2, 2)
all.mc.nn=matrix(0, 2, 2)
all.mc.nb=matrix(0, 2, 2)
perf.roc.tree = 0
perf.PR.tree = 0
perf.SS.tree = 0
perf.roc.svm = 0
perf.PR.svm = 0
perf.SS.svm = 0 
perf.roc.brglm = 0
perf.PR.brglm = 0
perf.SS.brglm = 0
perf.roc.rf = 0
perf.PR.rf = 0
perf.SS.rf = 0 
perf.roc.kknn = 0
perf.PR.kknn = 0
perf.SS.kknn = 0
perf.roc.nn = 0
perf.PR.nn = 0
perf.SS.nn = 0



	############################################# Decision TREE ###############################	
	
		tobj.tree = tune.rpart(Aggregate ~.,train[,3:length(train)], minsplit = c(20,30,40), cp = c(0.01,0.02,0.03), maxcompete = c(1,3,4), maxdepth = c(10,20,30))
		Bestminisplit = tobj.tree$best.parameters[[1]]
		Bestcp = tobj.tree$best.parameters[[2]]
		Bestmaxcompete = tobj.tree$best.parameters[[3]]
		Bestmaxdepth = tobj.tree$best.parameters[[4]]
		Data_Set.tree = rpart(train$Aggregate ~ ., data=train[,3:length(train)],  method="class", control= rpart.control(minsplit = Bestminisplit, cp = Bestcp, maxcompete = Bestmaxcompete, maxsurrogate = 4, usesurrogate = 1, xval = 0,surrogatestyle = 0, maxdepth = Bestmaxdepth))
		pred.tree = predict(Data_Set.tree,newdata=test[,3:(length(test)-1)], type="class")
		mc.tree = table(test$Aggregate, pred.tree)
		all.mc.tree = all.mc.tree + mc.tree
		
		pred.tree = predict(Data_Set.tree,newdata=test[,3:(length(test)-1)], type="prob")
		TREE_predictions = pred.tree[,2]
		TREE_labels = test$Aggregate
	
	##########################	Outputs		#################################		
		output1 = list(all.mc.tree)
		output2 = list(TREE_predictions,TREE_labels)
		output = list(output1,output2)
		return(output)
	
}

Query <- function()
{
channel = odbcDriverConnect(connection = "Driver={MySQL ODBC 5.1 Driver};Server=localhost;Database=aggreation_db;User=root;Password=mahmoud;", readOnlyOptimize = TRUE)
query = "select Concat(ORAA,CAST(pos AS CHAR),Mutant) as Mutation, Tango, dTango, Waltz, dWaltz, LIMBO, dLIMBO, Agadir, dAgadir, ddG, BLOSUM62, BLOSUM45, BLOSUM80, SIFT, Gain_Loss_Tango, Distance_to_Tango, Secondary_Structure,Consurf_Score,Consurf_Color,Consurf_B_E, Aggregate from aggreation_db.sequences as s inner join aggreation_db.short_stretch as sh on s.sequence_ID=sh.sequence_ID where Aggregate is not null and Aggregate != 'Yes/No' and Aggregate !='NO/Yes'";
Data_Set=sqlQuery(channel, query)
odbcClose(channel)
return(Data_Set)
}

Accuracy <- function(Confusion.Matrix)
{
	TP=Confusion.Matrix[2,2]
	FN=Confusion.Matrix[2,1]
	TN=Confusion.Matrix[1,1]
	FP=Confusion.Matrix[1,2]
	SEN = TP/(TP+FN)
	SPEC = TN/(FP+TN)
	ACC = (TP+TN)/(TP+TN+FP+FN)
	ERROR = 1.0 - ACC
	FDR = FP/(FP+TP)
	MCC = ((TP*TN)-(FP*FN))/(sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)))
	PREC = TP/(TP+FP)
	F_Measure = 2*((PREC * SEN)/(PREC + SEN))
	output<-list(SEN,SPEC,ACC,ERROR,FDR,MCC,PREC,F_Measure)
	names(output) <- c("SEN","SPEC","ACC","ERROR","FDR","MCC","PREC","F-Measure")
	return (output)
}


Data_Set = Query();
Pos_Set = data.frame()
Neg_Set = data.frame()
Pos_Num=0;
Neg_Num=0;
for(counter in 1:nrow(Data_Set))
{
	if(Data_Set[counter,length(Data_Set)]== "YES")
	{
		Pos_Set = rbind(Pos_Set,Data_Set[counter,])
		Pos_Num = Pos_Num + 1
	}
	else if (Data_Set[counter,length(Data_Set)]== "NO")
	{
		Neg_Set = rbind(Neg_Set,Data_Set[counter,])
		Neg_Num = Neg_Num + 1
	}
}
row.names(Pos_Set)=c(1:Pos_Num)
row.names(Neg_Set)=c(1:Neg_Num)

arr = array(0, c(8,8,10))
graph_arr = array(list(NULL), c(3,7,10))
begTime <- Sys.time()
Names =  c("TREE","SVM","BRGLM","LDA","RF","KKNN","NN","NB")

	TREE_predictions = list(NULL)
	TREE_labels = list(NULL)
	SVM_predictions = list(NULL)
	SVM_labels = list(NULL)
	BRGLM_predictions = list(NULL)
	BRGLM_labels = list(NULL)
	LDA_predictions = list(NULL)
	LDA_labels  = list(NULL)
	RF_predictions = list(NULL)
	RF_labels = list(NULL)
	KKNN_predictions = list(NULL)
	KKNN_labels = list(NULL)
	NN_predictions = list(NULL)
	NN_labels = list(NULL)
	NB_predictions = list(NULL)
	NB_labels = list(NULL)
	
for(j in 1:10)
{
	
	Suff_Pos = Pos_Set[sample.int(nrow(Pos_Set)),]
	Suff_Neg = Neg_Set[sample.int(nrow(Neg_Set)),]
	row.names(Suff_Pos)=c(1:nrow(Suff_Pos))
	row.names(Suff_Neg)=c(1:nrow(Suff_Neg))
	Sample_Pos_train_Num = ceiling(Pos_Num * (2/3))
	Sample_Neg_train_Num = ceiling(Neg_Num * (2/3))
	Sample_Pos_test_Num = Pos_Num - Sample_Pos_train_Num
	Sample_Neg_test_Num = Neg_Num - Sample_Neg_train_Num
	Pos_Start = Sample_Pos_train_Num + 1
	Neg_Start = Sample_Neg_train_Num + 1
	Traing.Set = rbind(Suff_Pos[1:Sample_Pos_train_Num,], Suff_Neg[1:Sample_Neg_train_Num,])
	Test.Set = rbind(Suff_Pos[Pos_Start:nrow(Pos_Set),], Suff_Neg[Neg_Start:nrow(Neg_Set),])
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	row.names(Test.Set)=c(1:nrow(Test.Set))
	Traing.Set = Traing.Set[sample.int(nrow(Traing.Set)),]
	Test.Set = Test.Set[sample.int(nrow(Test.Set)),]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	row.names(Test.Set)=c(1:nrow(Test.Set))

	print(paste("FOld number ",j," Started "))
	flush.console()
	

	r <- myfun(Traing.Set,Test.Set)
	print(j)
	print(r)
	
	#assign(paste(Names[counter], "_predictions[[1]]", sep=""),r[[2]][[1]])

	TREE_predictions[[j]] = r[[2]][[1]]
	TREE_labels[[j]] = r[[2]][[2]]
	
	pb <- winProgressBar("test progress bar", "Some information in %",0, 100, 50)
	Sys.sleep(0.5)
	u <- c(0, sort(runif(20, 0 ,100)), 100)
	for(b in u) 
	{
		Sys.sleep(0.1)
		info <- sprintf("%d%% done", round(b))
		setWinProgressBar(pb, b, sprintf("test (%x) (%s)",j , info), info)
	}
	Sys.sleep(5)
	close(pb)

	
	for(i in 1:1)
	{	
		RES = Accuracy(r[[1]][[i]])
		for(z in 1:8)
		{	
			var = as.double(RES[z])
			arr[z,i,j]=var;
		}
	}
}


mean_arr = array(0, c(8,8))
STD_arr = array(0, c(8,8))
for(r in 1:8)
{
	for(c in 1:1)
	{
		mean_arr[r,c] = mean(arr[r,c,])
		STD_arr[r,c] = sd(arr[r,c,])
	}
}

dimnames(mean_arr)[[1]] = c("SEN","SPEC","ACC","ERROR","FDR","MCC","PREC","F-Measure")
dimnames(mean_arr)[[2]] = c("tree","svm","brglm","lda","rf","kknn","nn","nb")
dimnames(STD_arr)[[1]] = c("SEN","SPEC","ACC","ERROR","FDR","MCC","PREC","F-Measure")
dimnames(STD_arr)[[2]] = c("tree","svm","brglm","lda","rf","kknn","nn","nb")

print(mean_arr)
print(STD_arr)

for(i in 1:1)
{
	pred <- prediction(get(paste(Names[1], "_predictions", sep="")), get(paste(Names[1], "_labels", sep="")))
	assign(paste("perf.roc.",Names[1], sep=""),performance(pred, "tpr","fpr"))
	assign(paste("perf.PR.",Names[1], sep=""),performance(pred, "prec", "rec"))
	assign(paste("perf.SS.",Names[1], sep=""),performance(pred, "sens", "spec"))
	assign(paste("perf.AUC.",Names[1], sep=""),performance(pred, "auc"))
	win.graph()
	plot( get(paste("perf.PR.",Names[1], sep="")) ,col="grey82",lty=3,colorize = TRUE)
	plot( get(paste("perf.PR.",Names[1], sep="")) ,lwd=3,avg="horizontal",spread.estimate="boxplot",add=TRUE)
	win.graph()
	plot( get(paste("perf.PR.",Names[1], sep="")) ,col="grey82",lty=3,colorize = TRUE)
	plot( get(paste("perf.PR.",Names[1], sep="")) ,lwd=3,avg="vertical",spread.estimate="boxplot",add=TRUE)
	win.graph()
	plot( get(paste("perf.PR.",Names[1], sep="")) ,col="grey82",lty=3,colorize = TRUE)
	plot( get(paste("perf.PR.",Names[1], sep="")) ,lwd=3,avg="threshold",spread.estimate="boxplot",add=TRUE)
	title(main = paste(Names[1],"Averaged PR curve"))
	
}





for (i in 1:8)
{
for(j in 1:14)
{
assign(paste("TP_",Names[i],"[",j,"]",sep=""), RES[[1,j]][2,2])
assign(paste("TN_",Names[i],"[",j,"]",sep=""), RES[[1,j]][1,1])
assign(paste("FP_",Names[i] ,"[",j,"]",sep=""), RES[[1,j]][1,2])
assign(paste("FN_",Names[i],"[",j,"]",sep=""), RES[[1,j]][2,1])
}
}
for(i in 1:14)
{
TP_tree = rbind(TP_tree,get(paste("TP_tree[",i,"]",sep="")))
TN_tree = rbind(TN_tree,get(paste("TN_tree[",i,"]",sep="")))
FP_tree = rbind(TN_tree,get(paste("FP_tree[",i,"]",sep="")))
FN_tree = rbind(TN_tree,get(paste("FN_tree[",i,"]",sep="")))
}