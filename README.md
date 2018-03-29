![alt text](http://www.vib.be/nl/biotechdag/PublishingImages/vib_tagline_pos_rgb.jpg)



## Prediction of protein aggregation inducing mutations

Code used for the dissertation presented in fulfillment of the requirements for the degree of Master of Science in Bioinformatics

Advisor: Prof. Dr. Ir. Yves Moreau, Prof. Dr. Ir. Joost Schymkowitz

Abstract:

Protein aggregation is the major reason for several human disorders, such as Alzheimer's, Parkinson's, Creutzfeldt-Jakob and type II diabetes diseases. Protein aggregation is essentially a self-association process in which many identical protein molecules come together to form a highly ordered structure of low solubility that are considered toxic to the cell. Many studies have been done before in this field in order to predict aggregating regions in wild type protein compared to their respective mutants. This doesn‟t necessarily mean that the protein will aggregate as usually the aggregating region is shielded inside the protein core. Mutations in aggregating regions will have to significantly disturb protein stability to in order for them to make them solvent accessible and cause protein aggregation. In this study we try to predict the effect of a mutation on protein aggregation phenomena by using both protein sequence features and structural features. We try different machine learning approaches and a naïve non-learning approach in order to find the best classifier. We additionally tried different training and testing methodologies for each classifier. Our main goal was to minimize false positive rate as each mutant wrongly predicted to be positive will increase validation costs and effort. Furthermore we also maximized high recall rate as the study is mainly interested in identifying aggregating mutants. The maintaining of both measures was our main challenge. The best approach we found at the end of the study was balancing our dataset using the undersampling technique and validating it using a “one protein out” scheme. Across all different learning methods the decision tree approach ultimately resulted in the best classifier.
