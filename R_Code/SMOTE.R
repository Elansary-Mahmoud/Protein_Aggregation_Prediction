
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
library('ggplot2')
library('reshape') 
library('DMwR')

myfun <- function(train,test)
{ 
	
all.mc.tree=matrix(0, 2, 2)
all.mc.svm=matrix(0, 2, 2)
all.mc.brglm=matrix(0, 2, 2)
all.mc.lda=matrix(0, 2, 2)
all.mc.kknn=matrix(0, 2, 2)
all.mc.nn=matrix(1, 2, 2)
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

############################################## Random Forest ########################################

		try = seq(500,1000,100)
		tobj.rf <- tune.randomForest(Aggregate ~ .,data= train[,3:length(train)], ntree = try )
		bestNtree <- tobj.rf$best.parameters[[1]]	
		Data_Set.rf = randomForest(train$Aggregate ~ ., data = train[,3:length(train)], importance=TRUE, ntree = bestNtree, mtry=sqrt(length(train)-1), replace=TRUE)
		pred.rf = predict(Data_Set.rf, newdata = test[,3:(length(test)-1)])
		mc.rf = table(test$Aggregate,pred.rf)
	
		all.mc.rf = all.mc.rf + mc.rf
				
		pred.rf = predict(Data_Set.rf,newdata = test[,3:(length(test)-1)], type="prob")
		RF_predictions = pred.rf[,2]
		RF_labels = test$Aggregate

	############################################# Decision TREE ###############################	
	
		Data_Set.tree = rpart(train$Aggregate ~ ., data=train[,3:length(train)],  method="class", control= rpart.control(minsplit = 20, minbucket = round(20/3), cp = 0.01, maxcompete = 3, maxsurrogate = 4, usesurrogate = 1, xval = 0,surrogatestyle = 0, maxdepth = 30))
		pred.tree = predict(Data_Set.tree,newdata=test[,3:(length(test)-1)], type="class")
		mc.tree = table(test$Aggregate, pred.tree)
		
		
		pred.tree = predict(Data_Set.tree,newdata=test[,3:(length(test)-1)], type="prob")
		TREE_predictions = pred.tree[,2]
		TREE_labels = test$Aggregate
		
	############################################# Support Vector Machine ###############################	
		test_seq = 2^(-3:10)	
		tobj.svm = tune.svm(Aggregate ~ .,data= train[,3:length(train)], gamma = c(0.045,test_seq), cost = c(1,test_seq))
		bestGamma = tobj.svm$best.parameters[[1]]
		bestC = tobj.svm$best.parameters[[2]]	
		Data_Set.svm = svm(train$Aggregate ~ ., train[,3:length(train)], type='C', kernel="radial", cost = bestC, gamma = bestGamma, probability = TRUE)
		pred.svm = predict(Data_Set.svm, newdata = test[,3:(length(test)-1)],probability = TRUE,decision.values = TRUE)
		mc.svm = table(test$Aggregate, pred.svm[1:nrow(test)])
	
		
		decision.svm = attributes(pred.svm)$decision.values
		SVM_predictions = decision.svm
		SVM_labels = test$Aggregate
		
	############################################ Logistic Regression ################################   
		Data_Set.brglm = brglm(train$Aggregate ~ .,family=binomial(logit),data=train[,3:length(Data_Set)],method = "brglm.fit")
		pred.brglm = predict(Data_Set.brglm,newdata=test[,3:(length(test)-1)])
		T.brglm = ilogit(pred.brglm)
		result.brglm = seq(1:1:nrow(test))
		for (j in 1:nrow(test))
		{ 
			if ( T.brglm[j] >= 0.5)
			{
			 result.brglm[j] = "YES";
			}
			else 
			{ 
			result.brglm[j] = "NO";
			}
		}

		mc.brglm = table(test$Aggregate, result.brglm)
		
		
		BRGLM_predictions = T.brglm
		BRGLM_labels = test$Aggregate
		
	############################################ Linear Discremenant Analysis ###########################
	    #attr(train$Secondary_Structure,"levels") = c("Beta strand","Helix","loop")
		Data_Set.lda = lda(train$Aggregate ~ .,train[,3:length(train)])
		pred.lda = predict(Data_Set.lda,newdata=test[,3:(length(test)-1)], type="class")
		mc.lda = table(test$Aggregate,pred.lda$class)
		
		
		LDA_predictions = pred.lda$posterior[,2]
		LDA_labels = test$Aggregate
		 
		#attr(train$Secondary_Structure,"levels") = c("Beta strand","Helix","loop","Turn")
		
	######################################## k-Nearest Neighbor ########################################
		tobj.kknn = train.kknn(train$Aggregate ~ ., train[,3:length(train)], kmax = 15,kernel = c("triangular", "rectangular", "epanechnikov", "biweight", "triweight", "cos", "inv", "gaussian"), distance = 1)
		bestKernel = tobj.kknn$best.parameters[[1]]
		bestK = tobj.kknn$best.parameters[[2]]
		Data_Set.kknn = kknn(train$Aggregate ~ ., train[,3:length(train)], test[,3:(length(test)-1)], k = bestK, distance = 1,kernel = bestKernel)
		pred.kknn = fitted(Data_Set.kknn)
		mc.kknn = table(test$Aggregate, pred.kknn)

		
		KKNN_predictions = Data_Set.kknn$prob[,2]
		KKNN_labels = test$Aggregate
		
	######################################### NN ###################################################

		tobj.nn = tune.nnet(Aggregate ~ ., data = train[,3:length(train)], size = c(1,5,10,15),decay = c(0,0.001,0.1))
		bestSize = tobj.nn$best.parameters[[1]]
		bestDecay = tobj.nn$best.parameters[[2]]
		Data_Set.nn = nnet(train$Aggregate ~ ., data = train[,3:length(train)], size = bestSize, rang = 0.1,decay = bestDecay, maxit = 200)
		pred.nn = predict(Data_Set.nn,newdata = test[,3:(length(test)-1)], type="class")
		mc.nn = table(test$Aggregate,pred.nn)

		
		pred.nn = predict(Data_Set.nn,newdata = test[,3:(length(test)-1)], type="raw")
		NN_predictions = pred.nn[,1]
		NN_labels = test$Aggregate
		
		##################################### naiveBayes  #########################################
		Data_Set.nb = naiveBayes(train$Aggregate ~ ., data = train[,3:length(train)])
		pred.nb = predict(Data_Set.nb, newdata = test[,3:(length(test)-1)], type="class")
		mc.nb = table(test$Aggregate, pred.nb)

		
		pred.nb = predict(Data_Set.nb, newdata = test[,3:(length(test)-1)], type="raw")
		NB_predictions = pred.nb[,2]
		NB_labels = test$Aggregate
	
	##########################	Outputs		#################################		
		output1 = list(mc.tree,mc.svm,mc.brglm,mc.lda,mc.rf,mc.kknn,mc.nn,mc.nb)
		output2 = list(TREE_predictions,TREE_labels,SVM_predictions,SVM_labels,BRGLM_predictions,BRGLM_labels,LDA_predictions,LDA_labels,RF_predictions,RF_labels,KKNN_predictions,KKNN_labels,NN_predictions,NN_labels,NB_predictions,NB_labels)
		output = list(output1,output2)
		return(output)
	
}

Query <- function()
{
channel = odbcDriverConnect(connection = "Driver={MySQL ODBC 5.1 Driver};Server=localhost;Database=aggreation_db;User=root;Password=mahmoud;", readOnlyOptimize = TRUE)
query = "select short_Name as Protein_Name,Concat(ORAA,CAST(pos AS CHAR),Mutant) as Mutation, s.Tango, dTango, s.Waltz, dWaltz, s.LIMBO, dLIMBO, s.Agadir, dAgadir, ddG, BLOSUM62, BLOSUM45, BLOSUM80, SIFT, Gain_Loss_Tango, Distance_to_Tango, Secondary_Structure,Consurf_Score,Consurf_Color,Consurf_B_E, Aggregate from aggreation_db.sequences as s inner join aggreation_db.short_stretch as sh on s.sequence_ID=sh.sequence_ID inner join aggreation_db.Proteins as P on s.Protein_ID = p.Uniprot_ID where Aggregate is not null  and short_Name ='p53' or short_Name = 'PTEN' or  (short_Name = 'alpha-GalA' and Aggregate != 'Yes/No' and Aggregate !='NO/Yes') or short_Name = 'b2m' or  short_Name = 'HypF-N' or short_Name = 'PAH' or short_Name ='Spc-SH3'";
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
	MCC = 0
	PREC = TP/(TP+FP)
	F_Measure = 2*((PREC * SEN)/(PREC + SEN))
	output<-list(SEN,SPEC,ACC,ERROR,FDR,MCC,PREC,F_Measure)
	names(output) <- c("SEN","SPEC","ACC","ERROR","FDR","MCC","PREC","F-Measure")
	return (output)
}


Total_Accuracy <- function(Confusion.Matrix)
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
Proteins = c('HypF-N','P53','PAH','PTEN','alpha-GalA','b2m','Spc-SH3')
Short_Names =  c('HypF','P53','PAH','PTEN','A_GalA','b2m','Spc_SH3')


arr = array(0, c(8,8,length(Proteins)))
RES = array(list(NULL), c(8,length(Proteins)))
RES2 = array(list(NULL), c(8,length(Proteins)))
begTime <- Sys.time()
Names =  c("tree","svm","brglm","lda","rf","kknn","nn","nb")

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
	########################################
	TREE_predictions2 = list(NULL)
	TREE_labels2 = list(NULL)
	SVM_predictions2 = list(NULL)
	SVM_labels2 = list(NULL)
	BRGLM_predictions2 = list(NULL)
	BRGLM_labels2 = list(NULL)
	LDA_predictions2 = list(NULL)
	LDA_labels2  = list(NULL)
	RF_predictions2 = list(NULL)
	RF_labels2 = list(NULL)
	KKNN_predictions2 = list(NULL)
	KKNN_labels2 = list(NULL)
	NN_predictions2 = list(NULL)
	NN_labels2 = list(NULL)
	NB_predictions2 = list(NULL)
	NB_labels2 = list(NULL)
	
	TMP = Data_Set
	for(p in 1:length(Proteins))
	{
	
	TMP = Data_Set[Data_Set$Protein_Name == Proteins[p], ]
	assign(paste(Short_Names[p],"_YES",sep=""),TMP[TMP$Aggregate == "YES", ])
	assign(paste(Short_Names[p],"_NO",sep=""),TMP[TMP$Aggregate == "NO", ])
	assign(paste(Short_Names[p],"_YES_Number",sep=""),nrow(get(paste(Short_Names[p],"_YES",sep=""))))
	assign(paste(Short_Names[p],"_NO_Number",sep=""),nrow(get(paste(Short_Names[p],"_NO",sep=""))))
	
	if(p != 6)
	{
		for(i in 1:(get(paste(Short_Names[p],"_YES_Number",sep=""))-get(paste(Short_Names[p],"_NO_Number",sep=""))))
		{
			random_number = sample(nrow(get(paste(Short_Names[p],"_NO",sep=""))),1)
			TMP2 = get(paste(Short_Names[p],"_NO",sep=""))[random_number,]
			assign(paste(Short_Names[p],"_NO",sep=""), rbind(get(paste(Short_Names[p],"_NO",sep="")),TMP2))
			
		}
	}


}
NEW_TMP = rbind(HypF_YES,P53_YES,PAH_YES,PTEN_YES,A_GalA_YES,b2m_YES,Spc_SH3_YES,HypF_NO,P53_NO,PAH_NO,PTEN_NO,A_GalA_NO,b2m_NO,Spc_SH3_NO)
row.names(NEW_TMP)=c(1:nrow(NEW_TMP))

for(j in 1:length(Proteins))
{
	NEW_DATA = SMOTE(Aggregate~., Data_Set, k = 5)

	Traing.Set = NEW_DATA[NEW_DATA$Protein_Name != Proteins[j], ]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	Traing.Set = Traing.Set[sample.int(nrow(Traing.Set)),]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	

	Test.Set = Data_Set[Data_Set$Protein_Name == Proteins[j], ]
	row.names(Test.Set)=c(1:nrow(Test.Set))
	Test.Set = Test.Set[sample.int(nrow(Test.Set)),]
	row.names(Test.Set)=c(1:nrow(Test.Set))


	
	print(paste("FOld number ",j," Started "))
	flush.console()

	#attr(Traing.Set$Secondary_Structure,"levels") = c("Beta strand","Helix","loop")

	r <- myfun(Traing.Set,Test.Set)

	#assign(paste(Names[counter], "_predictions[[1]]", sep=""),r[[2]][[1]])
	TREE_predictions[[j]] = r[[2]][[1]]
	TREE_labels[[j]] = r[[2]][[2]]
	SVM_predictions[[j]] = r[[2]][[3]]
	SVM_labels[[j]] = r[[2]][[4]]
	BRGLM_predictions[[j]] = r[[2]][[5]]
	BRGLM_labels[[j]] = r[[2]][[6]]
	LDA_predictions[[j]] = r[[2]][[7]]
	LDA_labels[[j]]  = r[[2]][[8]]
	RF_predictions[[j]] = r[[2]][[9]]
	RF_labels[[j]] = r[[2]][[10]]
	KKNN_predictions[[j]] = r[[2]][[11]]
	KKNN_labels[[j]] = r[[2]][[12]]
	NN_predictions[[j]] = r[[2]][[13]]
	NN_labels[[j]] = r[[2]][[14]]
	NB_predictions[[j]] = r[[2]][[15]]
	NB_labels[[j]] = r[[2]][[16]]

	
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

	
	for(i in 1:8)
	{	
		RES[[i,j]] = r[[1]][[i]]
}

}

runTime <- Sys.time() - begTime
################################################



for(j in 1:length(Proteins))
{

	Traing.Set = NEW_TMP[NEW_TMP$Protein_Name != Proteins[j], ]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	Traing.Set = Traing.Set[sample.int(nrow(Traing.Set)),]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	
	Test.Set2 = Data_Set[Data_Set$Protein_Name == Proteins[j], ]
	row.names(Test.Set2)=c(1:nrow(Test.Set2))
	Test.Set2 = Test.Set2[sample.int(nrow(Test.Set2)),]
	row.names(Test.Set2)=c(1:nrow(Test.Set2))



	
	print(paste("FOld number ",j," Started "))
	flush.console()

	#attr(Traing.Set$Secondary_Structure,"levels") = c("Beta strand","Helix","loop")

	r <- myfun(Traing.Set,Test.Set2)

	#assign(paste(Names[counter], "_predictions[[1]]", sep=""),r[[2]][[1]])
	TREE_predictions[[j]] = r[[2]][[1]]
	TREE_labels[[j]] = r[[2]][[2]]
	SVM_predictions[[j]] = r[[2]][[3]]
	SVM_labels[[j]] = r[[2]][[4]]
	BRGLM_predictions[[j]] = r[[2]][[5]]
	BRGLM_labels[[j]] = r[[2]][[6]]
	LDA_predictions[[j]] = r[[2]][[7]]
	LDA_labels[[j]]  = r[[2]][[8]]
	RF_predictions[[j]] = r[[2]][[9]]
	RF_labels[[j]] = r[[2]][[10]]
	KKNN_predictions[[j]] = r[[2]][[11]]
	KKNN_labels[[j]] = r[[2]][[12]]
	NN_predictions[[j]] = r[[2]][[13]]
	NN_labels[[j]] = r[[2]][[14]]
	NB_predictions[[j]] = r[[2]][[15]]
	NB_labels[[j]] = r[[2]][[16]]

	
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

	
	for(i in 1:8)
	{	
		RES[[i,j]] = r[[1]][[i]]
	}

}

runTime <- Sys.time() - begTime


arr = array(0, c(8,8,length(Proteins)))
for(j in 1:length(Proteins))
{
	
	for (i in 1:8)
	{
	print (Proteins[j])
	print (Names[i])
	if(length(RES[[i,j]]) == 2)
	{
		if(dimnames(RES[[i,j]])[2] == "YES")
		{
			RES[[i,j]] = cbind(matrix(0, 2, 1),RES[[i,j]])
		}
	else if (dimnames(RES[[i,j]])[2] == "NO")
		{
		 RES[[i,j]] = cbind(RES[[i,j]],matrix(0, 2, 1))
		}


	}

	print (RES[[i,j]])
		
	
		for (z in 1:8)
		{
			A = Accuracy(RES[[i,j]])
			var = as.double(A[z])
			arr[z,i,j]=var;
		}


}
}

dimnames(arr)[[1]] = c("SEN","SPEC","ACC","ERROR","FDR","MCC","PREC","F-Measure")
dimnames(arr)[[2]] = c("tree","svm","brglm","lda","rf","kknn","nn","nb")
dimnames(arr)[[3]] = Proteins



TP_tree = array(0,c(1,length(Proteins)))
TN_tree = array(0,c(1,length(Proteins)))
FP_tree = array(0,c(1,length(Proteins)))
FN_tree = array(0,c(1,length(Proteins)))

TP_svm = array(0,c(1,length(Proteins)))
TN_svm = array(0,c(1,length(Proteins)))
FP_svm = array(0,c(1,length(Proteins)))
FN_svm = array(0,c(1,length(Proteins)))

TP_brglm = array(0,c(1,length(Proteins)))
TN_brglm = array(0,c(1,length(Proteins)))
FP_brglm = array(0,c(1,length(Proteins)))
FN_brglm = array(0,c(1,length(Proteins)))

TP_lda = array(0,c(1,length(Proteins)))
TN_lda = array(0,c(1,length(Proteins)))
FP_lda = array(0,c(1,length(Proteins)))
FN_lda = array(0,c(1,length(Proteins)))

TP_rf = array(0,c(1,length(Proteins)))
TN_rf = array(0,c(1,length(Proteins)))
FP_rf = array(0,c(1,length(Proteins)))
FN_rf = array(0,c(1,length(Proteins)))

TP_kknn = array(0,c(1,length(Proteins)))
TN_kknn = array(0,c(1,length(Proteins)))
FP_kknn = array(0,c(1,length(Proteins)))
FN_kknn = array(0,c(1,length(Proteins)))

TP_nn = array(0,c(1,length(Proteins)))
TN_nn = array(0,c(1,length(Proteins)))
FP_nn = array(0,c(1,length(Proteins)))
FN_nn = array(0,c(1,length(Proteins)))

TP_nb = array(0,c(1,length(Proteins)))
TN_nb = array(0,c(1,length(Proteins)))
FP_nb = array(0,c(1,length(Proteins)))
FN_nb = array(0,c(1,length(Proteins)))

for(j in 1:length(Proteins))
{
	TP_tree[j] = RES[[1,j]][2,2]
	TN_tree[j] = RES[[1,j]][1,1]
	FP_tree[j] = RES[[1,j]][1,2]
	FN_tree[j] = RES[[1,j]][2,1]
	
	TP_svm[j] = RES[[2,j]][2,2]
	TN_svm[j] = RES[[2,j]][1,1]
	FP_svm[j] = RES[[2,j]][1,2]
	FN_svm[j] = RES[[2,j]][2,1]
	
	TP_brglm[j] = RES[[3,j]][2,2]
	TN_brglm[j] = RES[[3,j]][1,1]
	FP_brglm[j] = RES[[3,j]][1,2]
	FN_brglm[j] = RES[[3,j]][2,1]
	
	TP_lda[j] = RES[[4,j]][2,2]
	TN_lda[j] = RES[[4,j]][1,1]
	FP_lda[j] = RES[[4,j]][1,2]
	FN_lda[j] = RES[[4,j]][2,1]
	
	TP_rf[j] = RES[[5,j]][2,2]
	TN_rf[j] = RES[[5,j]][1,1]
	FP_rf[j] = RES[[5,j]][1,2]
	FN_rf[j] = RES[[5,j]][2,1]
	
	TP_kknn[j] = RES[[6,j]][2,2]
	TN_kknn[j] = RES[[6,j]][1,1]
	FP_kknn[j] = RES[[6,j]][1,2]
	FN_kknn[j] = RES[[6,j]][2,1]
	
	TP_nn[j] = RES[[7,j]][2,2]
	TN_nn[j] = RES[[7,j]][1,1]
	FP_nn[j] = RES[[7,j]][1,2]
	FN_nn[j] = RES[[7,j]][2,1]
	
	TP_nb[j] = RES[[8,j]][2,2]
	TN_nb[j] = RES[[8,j]][1,1]
	FP_nb[j] = RES[[8,j]][1,2]
	FN_nb[j] = RES[[8,j]][2,1]
	
	
}

#####################################################################################

Results = array(0,c(2,length(Names)))
All_Measurments = array (0,c(8,length(Names)))
for (i in 1:(length(Names)))
{
	assign(paste("Total_TP_",Names[i],sep=""),sum(get(paste("TP_",Names[i],sep=""))))
	assign(paste("Total_TN_",Names[i],sep=""),sum(get(paste("TN_",Names[i],sep=""))))
	assign(paste("Total_FP_",Names[i],sep=""),sum(get(paste("FP_",Names[i],sep=""))))
	assign(paste("Total_FN_",Names[i],sep=""),sum(get(paste("FN_",Names[i],sep=""))))
	
	assign(paste("Total_Confusion_",Names[i],sep=""),cbind(get(paste("Total_TN_",Names[i],sep="")),get(paste("Total_FP_",Names[i],sep=""))))
	assign(paste("Total_Confusion_",Names[i],sep=""),rbind(get(paste("Total_Confusion_",Names[i],sep="")),cbind(get(paste("Total_FN_",Names[i],sep="")),get(paste("Total_TP_",Names[i],sep="")))))
	assign(paste("Total_Measurment_",Names[i],sep=""),Total_Accuracy(get(paste("Total_Confusion_",Names[i],sep=""))))
	#print(paste("The Measurment for",Names[i],"is"))
	#print(get(paste("Total_Measurment_",Names[i],sep="")))
	Results[1,i] = (get(paste("Total_TP_",Names[i],sep="")))/((get(paste("Total_TP_",Names[i],sep="")))+(get(paste("Total_FN_",Names[i],sep=""))))
	Results[2,i] = (get(paste("Total_FP_",Names[i],sep="")))/((get(paste("Total_TN_",Names[i],sep="")))+(get(paste("Total_FP_",Names[i],sep=""))))
			
	for (j in 1:8)
		{
			var = as.double(get(paste("Total_Measurment_",Names[i],sep=""))[j])
			All_Measurments[j,i]=var;
		}

	
}
rownames(Results) = c("TPR","FPR")
colnames(Results) = Names
print(Results)
dimnames(All_Measurments)[[1]] = c("SEN","SPEC","ACC","ERROR","FDR","MCC","PREC","F-Measure")
dimnames(All_Measurments)[[2]] = c("tree","svm","brglm","lda","rf","kknn","nn","nb")
print(All_Measurments)


############################## Printing all proteins for each classifier #####################

for(class in 1:8)
{
	print(paste("Confusion Matrices of",Names[class]))
	for(pro in 1:length(Proteins))
	{
		print(paste("prediction of Protein",Proteins[pro]))
		print(RES2[class,pro])
	}
}
#save(list = ls(all=TRUE), file = "SMOTE.RData")

N = SMOTE(Aggregate~., Data_Set[Data_Set$Protein_Name == Proteins[1], ],perc.over = 100,perc.under = 200, k = 2)

table(N$Aggregate,N$Protein_Name)

N[N$Aggregate == "YES", ]
Data_Set[Data_Set$Protein_Name == Proteins[1], ]
TMP = as.data.frame(NULL);


for(i in 1:nrow(Data_Set))
{
	TMP = cbind(as.numeric(Test.Set[,"ddG"]),Test.Set[,length(Data_Set)])
	TMP = TMP[order(TMP[,1]),]
	Total_Accuracy(matrix(c(21,5,15,46),c(2,2),byrow =TRUE))
	for(j in 1:nrow(Data_Set))
	{
		threshold =  TMP[j,1]
		class_threshold = TMP[j,2]
		if( TMP[j,1] >= threshold)
		{
			
		}
	}
}

M = array(list(NULL),c(1,18))
library('Daim')
par(mfcol=c(3,6))

SPEC = array(0,c(1,7))
SEN = array(0,c(1,7))

for(j in 1:7)
{

Traing.Set = Data_Set[Data_Set$Protein_Name != Proteins[j], ]
for(loop in 1:18)
{
	if(loop !=16) 
	{
		assign(paste(colnames(Data_Set)[loop+2],"roc",sep="_"),roc(Traing.Set[,loop+2], Traing.Set$Aggregate, "YES"))
		flag = FALSE
		for(k in 1:length(attr(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_")),"row.names") ))
		{
			if(format(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_"))$TPR[k],digits=2) == 0.75 || format(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_"))$TPR[k],digits=2) == 0.76)
			{
				assign(paste(colnames(Data_Set)[loop+2],"thr",sep="_"),get(paste(colnames(Data_Set)[loop+2],"roc",sep="_"))$cutoff[k])
				print(j)
				print(colnames(Data_Set)[loop+2])
				print(get(paste(colnames(Data_Set)[loop+2],"thr",sep="_")))
				flag = TRUE
			}
	 }
	if(flag != TRUE)
	{
	assign(paste(colnames(Data_Set)[loop+2],"thr",sep="_"),0)

	}
	}
}


Test.Set = Data_Set[Data_Set$Protein_Name == Proteins[j], ]

tp = 0
fp = 0
tn = 0
fn = 0

for(i in 1:nrow(Test.Set))
{
	true = 0
	for(k in 1:18)
	{
		if(k != 16)
		{
			if(get(paste(colnames(Data_Set)[k+2],"thr",sep="_")) != 0)
			{
				if(Test.Set[i,k+2] >= get(paste(colnames(Data_Set)[k+2],"thr",sep="_")))
				{
					true = true + 1
				}
			}
        }
	}
	if(true >= 1)
	{
			if(Test.Set[i,"Aggregate"] == "YES")
			{
				tp= tp + 1;
			}
			if(Test.Set[i,"Aggregate"] == "NO")
			{
					fp= fp + 1;
			}
	}
	else
	{
			if(Test.Set[i,"Aggregate"] == "YES")
			{
				fn= fn + 1;
			}
			if(Test.Set[i,"Aggregate"] == "NO")
			{
				tn= tn + 1;
			}
	}
 

}
SEN[[1,j]] = as.numeric(Total_Accuracy(matrix(c(tn,fp,fn,tp),c(2,2),byrow = TRUE))[1])
SPEC[[1,j]] = as.numeric(Total_Accuracy(matrix(c(tn,fp,fn,tp),c(2,2),byrow = TRUE))[2])

}
print("SPEC")
sum(SPEC)/7
print("SEN")
sum(SEN)/7


for(j in 1:18)
{
	if(j !=16)
	{
		M[[1,j]] <- roc(Data_Set[,j+2], Data_Set$Aggregate, "YES")
		plot(M,main = "")
		#title(main =  colnames(Data_Set)[j])
	}
}

for(i in 1:18)
{ 
	print(colnames(Data_Set)[i+2])
	print(M[[1,i]])
}