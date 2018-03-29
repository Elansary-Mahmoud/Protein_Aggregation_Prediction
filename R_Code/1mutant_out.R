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

multiplot <- function(..., plotlist=NULL, cols) {
    require(grid)

    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)

    numPlots = length(plots)

    # Make the panel
    plotCols = cols                          # Number of columns of plots
    plotRows = ceiling(numPlots/plotCols) # Number of rows needed, calculated from # of cols

    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(plotRows, plotCols)))
    vplayout <- function(x, y)
        viewport(layout.pos.row = x, layout.pos.col = y)

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
        curRow = ceiling(i/plotCols)
        curCol = (i-1) %% plotCols + 1
        print(plots[[i]], vp = vplayout(curRow, curCol ))
    }

}

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
		Data_Set.lda = lda(train$Aggregate ~ .,train[,3:length(train)])
		pred.lda = predict(Data_Set.lda,newdata=test[,3:(length(test)-1)], type="class")
		mc.lda = table(test$Aggregate,pred.lda$class)
		
		
		LDA_predictions = pred.lda$posterior[,2]
		LDA_labels = test$Aggregate
		
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
query = "select short_Name as Protein_Name,Concat(ORAA,CAST(pos AS CHAR),Mutant) as Mutation, s.Tango, dTango, s.Waltz, dWaltz, s.LIMBO, dLIMBO, s.Agadir, dAgadir, ddG, BLOSUM62, BLOSUM45, BLOSUM80, SIFT, Gain_Loss_Tango, Distance_to_Tango, Secondary_Structure,Consurf_Score,Consurf_Color,Consurf_B_E, Aggregate from aggreation_db.sequences as s inner join aggreation_db.short_stretch as sh on s.sequence_ID=sh.sequence_ID inner join aggreation_db.Proteins as P on s.Protein_ID = p.Uniprot_ID where Aggregate is not null and Aggregate != 'Yes/No' and Aggregate !='NO/Yes'";
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


Data_Set = Query();
Proteins = c('Acp','alpha-GalA','Alpha-synuclein','b2m','GAPDH','human_gammaC-crystallin','human_neuroserpin','HypF-N','P16','P53','PAH','PTEN','SERCA2','SOD1','Spc-SH3')
Proteins
c('Acp','Alpha-synuclein','GAPDH','HypF-N','P16','P53','PAH','PTEN','SERCA2','SOD1','Spc-SH3','alpha-GalA','b2m','human_gammaC-crystallin')

arr = array(0, c(8,8,length(Proteins)))
RES = array(list(NULL), c(8,length(Proteins)))
#graph_arr = array(list(NULL), c(3,7,1))
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
	
for(j in 1:length(Proteins))
{

	Traing.Set = Data_Set[Data_Set$Protein_Name != Proteins[j], ]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	Traing.Set = Traing.Set[sample.int(nrow(Traing.Set)),]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	
	Test.Set = Data_Set[Data_Set$Protein_Name == Proteins[j], ]
	row.names(Test.Set)=c(1:nrow(Test.Set))
	Test.Set = Test.Set[sample.int(nrow(Test.Set)),]
	row.names(Test.Set)=c(1:nrow(Test.Set))

	print(paste("FOld number ",j," Started "))
	flush.console()

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