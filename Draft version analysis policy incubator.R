## Only use the parts of the manifestos writng about regions, otherwise you would compare the similarity across manifestos in general. 
## To determine which manifesto is most/least positive towards regional empowerment we can use sentiment analysis on the extracts focussing on regions.

## read the wordfish paper to gain more insight in what the command is really doing

## http://www.wordfish.org/uploads/1/2/9/8/12985397/wordfish_manual.pdf 
## http://www.wordfish.org/uploads/1/2/9/8/12985397/slapin_proksch_ajps_2008.pdf 
## explains poisson distribution: https://www.youtube.com/watch?v=BbLfV0wOeyc 
## https://italianpoliticalscience.files.wordpress.com/2013/07/27.pdf 



## https://www.youtube.com/watch?v=pFinlXYLZ-A
if (!require(tm)){
  install.packages("tm")
  library(tm)
}
if (!require(wordcloud)){
  install.packages("wordcloud")
  library(wordcloud)
}
if (!require(stringr)){
  install.packages("stringr")
  library(stringr)
}





## To import the data
file.choose()
"C:\\Users\\Mdl\\Desktop\\Documents\\Trial texts\\text1.txt"

folder <- "C:\\Users\\Mdl\\Desktop\\Documents\\Trial texts"
## when you run this you see the files in the folder 
list.files(path=folder)
filelist <- list.files(path=folder)
## Now I have recall-able list of my files a.k.a manifestos later.
filelist

## update your earlier filelist
filelist <- paste(folder, "\\", filelist, sep="")
filelist

## to paste the five texts together, each file is now a single row.
a <- lapply(filelist, FUN=readLines)
corpus <- lapply(a, FUN=paste, collapse=" ")





## https://www.youtube.com/watch?v=jCrQYOsAcv4
## cleaning data.
## to get rid of punctuation
corpus2 <- gsub(pattern="\\W", replace=" ", corpus)
## to get rid of digits
corpus2 <- gsub(pattern="\\d", replace=" ", corpus2)
## to lower case the corpus
tolower(corpus)
corpus2 <- tolower(corpus2)
## to remove stop words
corpus2 <- removeWords(corpus2, stopwords("english"))
## remove single letters that remained after the cleaning above
corpus2 <- gsub(pattern= "\\b[A-z]\\b{1}", replace=" ", corpus2)

## to apply stemming to the dictionary, this code had some issues but works now
install.packages("SnowballC")
library(SnowballC)
corpus2 <- stemDocument(corpus2, language = "english")

## to get rid of the white space
corpus2 <- stripWhitespace(corpus2)

## https://www.youtube.com/watch?v=pvjhm5TTd2A

## To create a wordcloud, such a cloud is more meaningfull if you do not apply stemming.
wordcloud(corpus2, random.order = FALSE, col=rainbow(3))

## THE CORPUS VARIABLE IS NOT OFFICIALLY RECOGNIZED BY R AS A CORPUS.
## to create the official corpus.
corpus3 <- Corpus(VectorSource(corpus2))
corpus3

## to create a term document 
tdm <- TermDocumentMatrix(corpus3)
tdm
m <- as.matrix(tdm)

## to label the documents (instead of 1,2,3,4 and 5)
colnames(m) <- c("CR", "JUVY", "TOT", "CHEESE", "BACON")
m





## Makes ONE but GROUPED worldcloud per document -> funny but not very usefull for the policy-incubator.
comparison.cloud(m)





## https://www.youtube.com/watch?v=jt4WzWoSCyo
## This explains how you can make sentiment scores of documents. This might be usefull for identifying which manifesto is most/least negative towards regional empowerment

## https://ptrckprry.com/course/ssd/data/positive-words.txt
## positive words are retrieved from the above dataset

## https://ptrckprry.com/course/ssd/data/negative-words.txt
## negative words are retrieved from the above dataset

## to import the two lexicons
opinion.lexicon.pos <- scan("positive-words.txt", what="character", comment.char =";")
opinion.lexicon.neg <- scan("negative-words.txt", what="character", comment.char =";")

## to determine how mant pos/neg words there are in each texts, create bags of words first
jj <- str_split(corpus2, pattern ="\\s+")

## to see how many pos/neg words there are in each of these bags.
lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.pos)))})
lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.neg)))})

## sentiment score = pos_score - neg_score, there higher the score the more positive the text is.
lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.pos))) -  sum(!is.na(match(x, opinion.lexicon.neg)))})

## to make a vector of the sentiment scores which is usefull to compute some descriptive statistics on these scores
score <- unlist(lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.pos))) -  sum(!is.na(match(x, opinion.lexicon.neg)))}))
mean(score)
sd(score)
hist(score)

## to obtain the largest/smallest sentiment score -> these you will use as a benchmark in Wordfish
max(score)
min(score)





## Moving on to Wordfish
## https://sites.temple.edu/tudsc/2017/11/09/use-wordfish-for-ideological-scaling/

install.packages("austin", repos = "http://R-Forge.R-project.org", 
                 dependencies = "Depends", type = "source")

## The code doesnt use all of the libraries
library(tm)
library(NLP)
library(austin)
library(ggplot2)

## Wordfish cannot read the matrix we created earlier, but it can if we make it a "wfm". 
word.count.matrix <- wfm(m, word.margin = 1)

## It is IMPORTANT to pick the benckmark texts carefullt here.
results <- wordfish(word.count.matrix,dir=c(7,8))
## This are the outcomes
results
plot(results)





## Some extra things we can do to interpret the results 
## http://www.joselkink.net/files/POL30430_Spring_2017_lab11.html

## https://www.rdocumentation.org/packages/quanteda/versions/1.5.2/topics/predict.textmodel_wordfish 

## https://www.rdocumentation.org/packages/quanteda/versions/1.5.2/topics/summary.textmodel_wordfish

## https://tutorials.quanteda.io/machine-learning/wordfish/ 

## https://rdrr.io/rforge/austin/man/wordfish.html 


