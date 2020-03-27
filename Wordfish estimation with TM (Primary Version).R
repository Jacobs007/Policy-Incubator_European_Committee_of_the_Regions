#######################################################################################################################################################################################################
#                                                                                                                                                                                                     #
## READ ME                                                                                                                                                                                            #
#                                                                                                                                                                                                     #
## Purpose:                                                                                                                                                                                           #
## This code is written for the statistical analysis software R and belongs to the common part of the Policy Incubator 2020, European Institute, London School of Economics and Political Science.    #
#                                                                                                                                                                                                     #
## Project:                                                                                                                                                                                           #
## European Committee of the Regions (Policy-Incubator 2020)                                                                                                                                          #
#                                                                                                                                                                                                     #
## Authors:                                                                                                                                                                                           #
## Tim Jacobs                                                                                                                                                                                         # 
## Christian Zörner                                                                                                                                                                                   #
## Nicole Lawler                                                                                                                                                                                      #
## Hande Taner                                                                                                                                                                                        #
#                                                                                                                                                                                                     #
## Input Data:                                                                                                                                                                                        #
## Chunks of text from the 25 manifestos that contain words from the list of terms. (Excluded are manifestos with zero search hits).                                                                  #
#                                                                                                                                                                                                     #
#                                                                                                                                                                                                     #
## List of Terms:                                                                                                                                                                                     # 
## [city/cities, commune, CoR, county, devolution, district, local, mayor, metropol, municipal, province, regio, rural, sub national, subsidiarity, town, urban, village]                             #
#                                                                                                                                                                                                     # 
## Bibliography:                                                                                                                                                                                      #
## Wordfish Manual: http://www.wordfish.org/uploads/1/2/9/8/12985397/wordfish_manual.pdf                                                                                                              #
## Original paper that introduces Wordfish: http://www.wordfish.org/uploads/1/2/9/8/12985397/slapin_proksch_ajps_2008.pdf                                                                             #
## Explanation Poisson Distribution: https://www.youtube.com/watch?v=BbLfV0wOeyc                                                                                                                      #
## TM Package: https://cran.r-project.org/web/packages/tm/tm.pdf                                                                                                                                      #
## Quanteda Package: https://quanteda.io/                                                                                                                                                             #
#  **More references are provides in text**                                                                                                                                                           #
#                                                                                                                                                                                                     #
# THE GENERAL DISCLAIMER APPLIES                                                                                                                                                                      #
#                                                                                                                                                                                                     #
#######################################################################################################################################################################################################



## PART 1 - IMPORTING THE DATA
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

file.choose()
"C:\\Users\\Mdl\\Desktop\\Documents\\Trial texts\\text1.txt"

folder <- "C:\\Users\\Mdl\\Desktop\\Documents\\Trial texts"
list.files(path=folder)
filelist <- list.files(path=folder)
filelist <- paste(folder, "\\", filelist, sep="")
a <- lapply(filelist, FUN=readLines)
corpus <- lapply(a, FUN=paste, collapse=" ")


## PART 2 - CLEANING THE DATA (1)
## https://www.youtube.com/watch?v=jCrQYOsAcv4
## To get rid of punctuation:
corpus2 <- gsub(pattern="\\W", replace=" ", corpus)
## To get rid of digits:
corpus2 <- gsub(pattern="\\d", replace=" ", corpus2)
## To lower case the corpus:
corpus2 <- tolower(corpus2)
## To remove stop words:
corpus2 <- removeWords(corpus2, stopwords("english"))
## To remove single letters that remained after the above cleaning:
corpus2 <- gsub(pattern= "\\b[A-z]\\b{1}", replace=" ", corpus2)
## To stem the dictionary:
install.packages("SnowballC")
library(SnowballC)
corpus2 <- stemDocument(corpus2, language = "english")
## To get rid of the white space:
corpus2 <- stripWhitespace(corpus2)


## DATA INSPECTION - WORDCLOUD
## https://www.youtube.com/watch?v=pvjhm5TTd2A
wordcloud(corpus2, random.order = FALSE, col=rainbow(3))


## PART 3 - CREATING A TERM DOCUMENT MATRIX (TDM)
## To create a corpus:
corpus3 <- Corpus(VectorSource(corpus2))
## To create a term document:
tdm <- TermDocumentMatrix(corpus3)


## PART 4 - CLEANING THE DATA (2)
## Drop all terms that do not appear in at least 8% of the manifestos (0.92 is the percentage of cells being zero).
## We only have 25 manifestos: 1/25=0.04 * 2 = 0.08 -> 1-0.08=0.92
tdm <- removeSparseTerms(tdm, 0.92)


## PART 5 - STORING THE TDM 
## The matrix used for analysis:
m <- as.matrix(tdm)


## DATA INSPECTION - TDM
## Genderal info on tdm:
inspect(tdm)
## Terms that occur more than x times in the tdm:
findFreqTerms(tdm, 50)


## PART 6 - LABELLING THE TEXTS
## party (party-group, number of seats in the European Parliament held, country, number of words extracted from the party's manifesto)
colnames(m) <- c("Centerpartiet (ReEU,2,SE,348)", "Centre Democrate Humaniste (EPP,1,BE,1.081)", "Ceská pirátská strana (Gr/EFA,3,CZ,675)", "Ciudadanos...(ReEU,7,ES,582)", "Demokratesch Parte (ReEU,2,LU,287)", "Det Konservative Folkeparti (EPP,1,DK,408)", "Det Radikale Venstre (ReEU,2,DK,102)", "Die Grünen (Gr/EFA,21,DE,4.574)", "Eesti Keskerakond (ReEU,1,EE,179)", "Forza Italia (EPP,6,IT,209)", "Greek Solution (ECR,1,GR,3.302)", "GroenLinks (Gr/EFA,3,NL,1.120)", "Kansallinen Kokoomus (EPP,3,FI,148)", "Kristdemokraterna (EPP,2,SE,229)", "Komunistická strana...(GUE/NGL,1,CZ,481)", "Nieuw-Vlaamse Alliantie (ECR,3,BE,6.530)", "Partido Socialista Obrero... (S&D,20,ES,412)", "Partido Socialista (S&D,9,PT,146)", "Partij van de Arbeid (S&D,6,NL,97)", "Perussuomalaiset (ID,2,FI,202)", "Parti du Travail de Belgique (GUE/NGL,1,BE,1.968)", "Rassemblement National (ID,22,FR,1.433)", "Suomen Keskusta (ReEU,2,FI,665)", "Partei Mensch Umwelt...(GUE/NGL,1,DE,916)", "Venstre (ReEU,3,DK,593)")


## DATA INSPECTION - THINKING ABOUT AN APPROPRIATE BENCHMARK FOR WORDFISH

## SENTIMENT ANALYSIS
## To determine which manifestos have the most and least positive tone.

## https://www.youtube.com/watch?v=jt4WzWoSCyo

## To retrieve lists of positive and negative words:
## Bing Liu, Minqing Hu and Junsheng Cheng. "Opinion Observer: Analyzing ; and Comparing Opinions on the Web." Proceedings of the 14th ; International World Wide Web conference (WWW-2005), May 10-14, ; 2005, Chiba, Japan.
## https://ptrckprry.com/course/ssd/data/positive-words.txt
## https://ptrckprry.com/course/ssd/data/negative-words.txt

## To import the two lexicons:
opinion.lexicon.pos <- scan("positive-words.txt", what="character", comment.char =";")
opinion.lexicon.neg <- scan("negative-words.txt", what="character", comment.char =";")
## To determine how many pos/neg words there are in each text; create bags of words first:
jj <- str_split(corpus2, pattern ="\\s+")
## To see how many pos/neg words there are in each of these bags:
lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.pos)))})
lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.neg)))})
## Sentiment score = pos_score - neg_score; there higher the score the more positive the text is:
lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.pos))) -  sum(!is.na(match(x, opinion.lexicon.neg)))})
## To make a vector of the sentiment scores; useful to compute some descriptive statistics on these scores:
score <- unlist(lapply(jj, function(x){ sum(!is.na(match(x, opinion.lexicon.pos))) -  sum(!is.na(match(x, opinion.lexicon.neg)))}))
mean(score)
sd(score)
hist(score)
## To obtain the largest/smallest sentiment score:
max(score)
min(score)
## Note that the sentiment analysis does not work well if texts are not equally long and either positive or negative terms are very uncommon. 
## Negative terms are likely to be little present in the manifestos we deal with and the manifestos vary greatly in length. 
## Nevertheless, overall might conclude that the manifestos write about regions in a positive manner.

## SIDE NOTE - SENTIMENT ANALYSIS;
## The intention of the sentiment analysis is to identify the corpus' most extreme texts (regarding regional empowerment).
## However, the (positive) tone of a text imperfectly captures the manifesto's stance towards (more) regional empowerment.

## FREQUANCY REGIO
## The frequency tables we created outside of R, show that the most frequently used term to refer to sub-national political issues is "regio(ns)". 
## The term is most often mentioned in the manifesto of "Nieuw-Vlaamse Alliantie" and zero times in a handful of other manifestos.

## POLITICAL LEFT-RIGHT DIMENSION
## Benoit, K. and Laver, M. (2012). The dimensionality of political space: Epistemological and methodological considerations. European Union Politics. 13(2) 194-218
## Fig.8 of this paper shows that European Parliament party-groups can be classified on a left-to-right dimension as: GUE/NGL, Green/EFA, S&D, ALDE, EPP, ECR and EFD.
## This classification is slightly outdated but based on it we create an updated left-right dimension: GUE/NGL, Green/EFA, S&D, Renew Europe, EPP, ECR, ID.


## DECIDING THE WORDFISH BENCHMARK
## Considering the three candidate benchmarks obtained through sentiment analysis, frequency counts and the political left-right dimension, it eventually was decided to benchmark the Wordfish estimation on the political left-right dimension.
## Benchmarking based on the political left-right dimension allows for the most intuitive interpretation of the Wordfish estimates. Moreover, it allows to directly test the obtained estimates for the presence of the expected political left-right pattern.
## The party from which manifesto contains most extracted text from respectively the GUE/NGL and ECR-group, function as the manifestos to which the Wordfish estimates are benchmarked.
## The parties associated with the ID are arguably more right-wing than the ECR, but because these parties typically take a populistic stance, they form less of stable/interpretable benchmark, it is thus opted to take a party affiliated to the ECR as upper boundary benchmark.
## This yields the following benchmark manifestos:
### GUE/NGL: "Parti du Travail de Belgique"
### ECR: "Nieuw-Vlaamse Aliantie"


## PART 7 - WORDFISH
## https://sites.temple.edu/tudsc/2017/11/09/use-wordfish-for-ideological-scaling/

install.packages("austin", repos = "http://R-Forge.R-project.org", 
                 dependencies = "Depends", type = "source")
library(tm)
library(NLP)
library(austin)
library(ggplot2)

## Wordfish cannot read the matrix "m": 
word.count.matrix <- wfm(m, word.margin = 1)

## Conducting the estimation:
results <- wordfish(word.count.matrix,dir=c(21,16)) 
results
plot(results, main="Estimated Political Positions of Party Manifestos", xlab="Estimated Political Position (Standardized)")

## https://www.r-bloggers.com/r-tutorial-series-labeling-data-points-on-a-plot/ 
install.packages("calibrate")
library(calibrate)
## Y-axis (psi) = word fixed effect
## X-axis (beta) = word specific weight capturing the importance of word "j" in discriminating between positions.
textxy(results$beta, results$psi, results$words)



## FINAL REMARKS -  VALIDITY ESTIMATION RESULTS
## 1) Not all manifestos are equally long or have the same writing style.
## 2) Quality of the translation may differ between languages/manifestos.
## 3) Some manifestos contain no or very little relevant data, this is indication of the party focussing little on regions.
## 4) Manifestos discuss regions in very different contexts, this blurs our analysis. 
## 5) The chunks of texts that were extracted from the manifestos have a size ranging between about 30 to 60 words each.
## 6) Data is prepared by all four researchers, this may have introduced some biases in the selection of the 30-60 words surrounding a term. 
