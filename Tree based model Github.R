## Importing the data

df = read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data",
                       sep=",",header=F,col.names=c("Class", "Alcohol", "Malic acid", "Ash", "Alcalinity of ash", "Magnesium", "Total phenols", "Flavanoids", "Nonflavanoid phenols", "Proanthocyanins", "Color intensity", "Hue", "OD280/OD315 of diluted wines", "Proline"),
                       fill=FALSE,strip.white=T)

dim(df)
sum(is.na(df))
summary(df)


## Exploratory Data Analysis

library(skimr)
skim(df)
cor(df)
barplot(table(df$Class), 
        xlab='Class', 
        ylab='Number of Instances', 
        main='Class Distribution in the Wine Dataset',
        col = c("red","blue","green"))

hist(df$Alcohol, 
     main='Distribution of Alcohol Content in Wines',
     xlab='Alcohol Content',
     ylab='Frequency',
     col='lightblue',
     border='black',
     breaks = 20)

plot(df$Alcohol, df$`Color intensity`, 
     xlab='Alcohol Content', 
     ylab='Color Intensity',
     main='Scatter Plot: Alcohol vs. Color Intensity',
     col=df$Class)

boxplot(df$Alcohol ~ df$Class,
        xlab='Class',
        ylab='Alcohol Content',
        main='Boxplot: Alcohol Content by Class',
        col=c('lightblue', 'lightgreen', 'lightcoral'),
        border='black')


## Building the model

df$Class <- as.factor(df$Class)
library(tree)
tree_fit = tree(Class~. , df)
summary(tree_fit)
tree_fit
plot(tree_fit)
text(tree_fit, pretty=0)


set.seed(3)
train_index=sample(1:nrow(df),150)
data_train=df[train_index,]
data_test=df[-train_index,]

tree.df=tree(Class~.,data_train)
plot(tree.df)
text(tree.df,pretty=0)

tree.pred=predict(tree.df,data_test,type="class")
table(tree.pred, data_test$Class)


cv.df=cv.tree(tree.df,FUN=prune.misclass)
cv.df
plot(cv.df)

prune.df=prune.misclass(tree.df,best=5)
plot(prune.df);text(prune.df,pretty=0)

tree.pred_prune=predict(prune.df,data_test,type="class")
tree.pred_prune = as.factor(tree.pred_prune)
mtab = table(tree.pred_prune, data_test$Class)
library(caret)
confusionMatrix(mtab)

