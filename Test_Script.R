rm(list=ls(all=TRUE)) 
library('rpart')
library('randomForest')
library('ROCR')
library('Daim')
library('kknn')
library('nnet')
library('RODBC')
library('MASS')
library('faraway')
library('e1071')
library('brglm')
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


channel = odbcDriverConnect(connection = "Driver={MySQL ODBC 5.1 Driver};Server=localhost;Database=aggreation_db;User=root;Password=mahmoud;", readOnlyOptimize = TRUE)
query = "select s.Tango, dTango, s.Waltz, dWaltz, s.LIMBO, dLIMBO, s.Agadir, dAgadir, ddG, BLOSUM62, BLOSUM45, BLOSUM80, SIFT, Gain_Loss_Tango, Distance_to_Tango,Consurf_Score,Consurf_Color from aggreation_db.sequences as s inner join aggreation_db.short_stretch as sh on s.sequence_ID=sh.sequence_ID inner join aggreation_db.Proteins as P on s.Protein_ID = p.Uniprot_ID where Aggregate is not null  and short_Name ='p53' or short_Name = 'PTEN' or  (short_Name = 'alpha-GalA' and Aggregate != 'Yes/No' and Aggregate !='NO/Yes') or short_Name = 'b2m' or  short_Name = 'HypF-N' or short_Name = 'PAH' or short_Name ='Spc-SH3'";
Data_Set=sqlQuery(channel, query)
odbcClose(channel)

SPEC = array(0,c(1,7))
SEN = array(0,c(1,7))
Proteins = c('HypF-N','P53','PAH','PTEN','alpha-GalA','b2m','Spc-SH3')
sum = matrix(0,2,2)
for(j in 1:7)
{

Traing.Set = Data_Set[Data_Set$Protein_Name != Proteins[j], ]
for(loop in 1:(length(Data_Set)-3))
{
	#win.graph();
	#M <- roc(Traing.Set[,loop+2], Traing.Set$Aggregate, "YES")
	#plot(M,main = "")
	#title(main =  paste(colnames(Data_Set)[loop+2],"Protein is removed",Proteins[j]))
	if(loop !=10) 
	{
		assign(paste(colnames(Data_Set)[loop+2],"roc",sep="_"),roc(Traing.Set[,(loop+2)], Traing.Set$Aggregate, "YES"))
		flag = FALSE
		for(k in 1:length(attr(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_")),"row.names") ))
		{
			if(format(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_"))$FPR[k],digits=1) == 0.2 && flag !=TRUE || format(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_"))$FPR[k],digits=2) == 0.25 && flag !=TRUE )
			{
				assign(paste(colnames(Data_Set)[loop+2],"thr",sep="_"),get(paste(colnames(Data_Set)[loop+2],"roc",sep="_"))$cutoff[k])
				print(j)
				print(colnames(Data_Set)[loop+2])
				#print(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_")))
				print(get(paste(colnames(Data_Set)[loop+2],"thr",sep="_")))
				print(format(get(paste(colnames(Data_Set)[loop+2],"roc",sep="_"))$FPR[k],digits=2))
				
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
	for(k in 1:(length(Data_Set)-3))
	{
		if(k != 10)
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
sum = sum + matrix(c(tn,fp,fn,tp),c(2,2),byrow = TRUE)
print(matrix(c(tn,fp,fn,tp),c(2,2),byrow = TRUE))

}

Final = matrix(Total_Accuracy(sum),1,8,byrow=TRUE)
colnames(Final) = c("SEN","SPEC","ACC","ERROR","FDR","MCC","PREC","F-Measure")
print(Final)

for (i in 1:8)
{
	print(get(paste(colnames(Data_Set)[i+2],"roc",sep="_")))
}


channel = odbcDriverConnect(connection = "Driver={MySQL ODBC 5.1 Driver};Server=localhost;Database=aggreation_db;User=root;Password=mahmoud;", readOnlyOptimize = TRUE)
query = "select short_Name as Protein_Name,Concat(ORAA,CAST(pos AS CHAR),Mutant) as Mutation, s.Tango, dTango, s.Waltz, dWaltz, s.LIMBO, dLIMBO, s.Agadir, dAgadir, ddG, BLOSUM62, BLOSUM45, BLOSUM80, SIFT, Gain_Loss_Tango, Distance_to_Tango, Secondary_Structure,Consurf_Score,Consurf_Color,Consurf_B_E, Aggregate from aggreation_db.sequences as s inner join aggreation_db.short_stretch as sh on s.sequence_ID=sh.sequence_ID inner join aggreation_db.Proteins as P on s.Protein_ID = p.Uniprot_ID where Aggregate is not null  and short_Name ='p53' or short_Name = 'PTEN' or  (short_Name = 'alpha-GalA' and Aggregate != 'Yes/No' and Aggregate !='NO/Yes') or short_Name = 'b2m' or  short_Name = 'HypF-N' or short_Name = 'PAH' or short_Name ='Spc-SH3'";
Data_Set=sqlQuery(channel, query)
odbcClose(channel)

M = array(list(NULL),c(1,18))
library('Daim')

par(mfcol=c(3,6))
for(j in 1:((length(Data_Set)-1)))
{

		
		M[[1,j]] <- roc(Data_Set[,j], Data_Set$Aggregate, "YES")
		plot(M[[1,j]],main = "")
		title(main =  colnames(Data_Set)[j])
}


NO = Data_Set[Data_Set$Aggregate == "NO", ]
rownames(NO) = c(1:nrow(NO)) 
boxplot(NO$ddG,xlab="ddG",ylab="Values")
boxplot(NO$dTango,xlab="difference of Tango",ylab="Values")






############################### TEST ################################
channel = odbcDriverConnect(connection = "Driver={MySQL ODBC 5.1 Driver};Server=localhost;Database=aggreation_db;User=root;Password=mahmoud;", readOnlyOptimize = TRUE)
query = "select short_Name as Protein_Name,Concat(ORAA,CAST(pos AS CHAR),Mutant) as Mutation,s.Tango ,ddG, Aggregate from aggreation_db.sequences as s inner join aggreation_db.short_stretch as sh on s.sequence_ID=sh.sequence_ID inner join aggreation_db.Proteins as P on s.Protein_ID = p.Uniprot_ID where Aggregate is not null and Aggregate != 'Yes/No' and Aggregate !='NO/Yes' and short_Name !='Alpha-synuclein'  and short_Name !='p16' and short_Name != 'GAPDH' and short_Name != 'human_gammaC-crystallin' ";

Data_Set=sqlQuery(channel, query)
odbcClose(channel)
#eig = ?eigen(Data_Set[,3:length(Data_Set)])

Proteins = c('Acp','HypF-N','P53','PAH','PTEN','SERCA2','SOD1','Spc-SH3','alpha-GalA','b2m','human_neuroserpin')

mc.rf = array(list(NULL), c(1,length(Proteins)))
mc.svm = array(list(NULL), c(1,length(Proteins)))
mc.nn = array(list(NULL), c(1,length(Proteins)))
mc.tree = array(list(NULL), c(1,length(Proteins)))
mc.lda = array(list(NULL), c(1,length(Proteins)))

for (j in 1:length(Proteins))
{
	
	Traing.Set = Data_Set[Data_Set$Protein_Name != Proteins[j], ]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	Traing.Set = Traing.Set[sample.int(nrow(Traing.Set)),]
	row.names(Traing.Set)=c(1:nrow(Traing.Set))
	
	Test.Set = Data_Set[Data_Set$Protein_Name == Proteins[j], ]
	row.names(Test.Set)=c(1:nrow(Test.Set))
	Test.Set = Test.Set[sample.int(nrow(Test.Set)),]
	row.names(Test.Set)=c(1:nrow(Test.Set))
	train = Traing.Set
	test = Test.Set
	
		Data_Set.lda = lda(train$Aggregate ~ .,train[,3:length(train)])
		pred.lda = predict(Data_Set.lda,newdata=test[,3:(length(test)-1)], type="class")
		mc.lda[[1,j]] = table(test$Aggregate,pred.lda$class)

		#Data_Set.brglm = glm(Aggregate ~ .,family=binomial(logit),data=train[,3:length(Data_Set)])
		#print(summary(Data_Set.brglm))
		#pred.brglm = predict(Data_Set.brglm,newdata=test[,3:(length(test)-1)])
		#T.brglm = ilogit(pred.brglm)
		#result.brglm = seq(1:1:nrow(test))
		#for (i in 1:nrow(test))
		#{ 
			#if ( T.brglm[i] >= 0.5)
			#{
			 #result.brglm[i] = "YES";
			#}
			#else 
			#{ 
			#result.brglm[i] = "NO";
			#}
		#}
#
		#mc.brglm[[1,j]] = table(test$Aggregate, result.brglm)
		

		Data_Set.tree = rpart(train$Aggregate ~ ., data=train[,3:length(train)],  method="class", control= rpart.control(minsplit = 20, minbucket = round(20/3), cp = 0.01, maxcompete = 3, maxsurrogate = 4, usesurrogate = 1, xval = 10,surrogatestyle = 0, maxdepth = 30))
		pred.tree = predict(Data_Set.tree,newdata=test[,3:(length(test)-1)], type="class")
		mc.tree[[1,j]] = table(test$Aggregate, pred.tree)
		#win.graph()
		#plot(Data_Set.tree,uniform=F)         
		#text(Tree.ind,splits=T,all=T)              # puts names on tree plot
		#text(Data_Set.tree, use.n=TRUE, all=TRUE, cex=.8)         # puts names on tree plot
		#title("g1_ind tree for a selection of variables")
		#plotcp(Data_Set.tree)
		#try = seq(500,1000,100)
		#tobj.rf <- tune.randomForest(Aggregate ~ .,data= train[,3:length(train)], ntree = try )
		#bestNtree <- tobj.rf$best.parameters[[1]]	
		#Data_Set.rf = randomForest(train$Aggregate ~ ., data = train[,3:length(train)], importance=TRUE, ntree = bestNtree, mtry=sqrt(length(train)-1), replace=TRUE, cutoff=c(0.50,0.50))
		#pred.rf = predict(Data_Set.rf, newdata = test[,3:(length(test)-1)])
		#mc.rf[[1,j]] = table(test$Aggregate,pred.rf)
#
		#Data_Set.svm = svm(train$Aggregate ~ ., train[,3:length(train)], type='C', kernel="linear", probability = TRUE)
		#pred.svm = predict(Data_Set.svm, newdata = test[,3:(length(test)-1)],probability = TRUE,decision.values = TRUE)
		#mc.svm[[1,j]] = table(test$Aggregate, pred.svm[1:nrow(test)])
		#tobj.nn = tune.nnet(Aggregate ~ ., data = train[,3:length(train)], size = c(1,5,10,15),decay = c(0,0.001,0.1))
		#bestSize = tobj.nn$best.parameters[[1]]
		#bestDecay = tobj.nn$best.parameters[[2]]
		#Data_Set.nn = nnet(train$Aggregate ~ ., data = train[,3:length(train)], size = bestSize, rang = 0.1,decay = bestDecay, maxit = 200)
		#pred.nn = predict(Data_Set.nn,newdata = test[,3:(length(test)-1)], type="class")
		#mc.nn[[1,j]] = table(test$Aggregate,pred.nn)

}

spec = 0
sen = 0
sum = matrix(0, 2, 2)
for (i in 1:7)
	{
	if(length(mc.lda[[1,i]]) == 2)
	{
		if(dimnames(mc.lda[[1,i]])[2] == "YES")
		{
			mc.lda[[1,i]] = cbind(matrix(0, 2, 1),mc.lda[[1,i]])
		}
	else if (dimnames(mc.lda[[1,i]])[2] == "NO")
		{
		 mc.lda[[1,i]] = cbind(mc.lda[[1,i]],matrix(0, 2, 1))
		}

	}
}

for(j in 1:7)
{
	#print(mc.brglm[[1,j]])
	sum = sum + mc.lda[[1,j]]
}
Total_Accuracy(sum)
	spec = spec/7
	sen = sen/7
	print(spec)
	print(sen)
for (i in 1:7)
{
	print(mc.tree[[1,i]])
}