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
## Quanteda Package: https://quanteda.io/                                                                                                                                                             #
#  **More references are provided at the bottom of the script**                                                                                                                                       #
#                                                                                                                                                                                                     #
# THE GENERAL DISCLAIMER APPLIES                                                                                                                                                                      #
#                                                                                                                                                                                                     #
#######################################################################################################################################################################################################



## INSTALL REQUIRRED PACKAGES
install.packages("quanteda")
require(quanteda)
install.packages("readtext")
require(readtext)
install.packages("quanteda.textmodels")
require(quanteda.textmodels)


## PART 1 - IMPORTING THE DATA
dat_txtmultiple2 <- readtext("C:\\Users\\Mdl\\Desktop\\Documents\\Trial texts",
                             docvarsfrom = "filenames")
## It would be neater if each document was assigned a "new" name here, otherwise the ".txt" extension enters the reference name of the text. 


## PART 2 - CREATING A CORPUS                             
corpus2 <- corpus(dat_txtmultiple2)
summary(corpus2)


## PART 3 - CREATING A DOCUMENT FEATURE-MATRIX & CLEANING THE DATA
Z <- dfm(corpus2, tolower = TRUE, stem = TRUE, remove = stopwords("english"), remove_punct = TRUE)
## To drop the most sparse terms (words need to be present in at least two texts -> 2/25=0.08 to obtain better Wordfish estimates):
Z <- dfm_trim(Z, min_docfreq = 0.08)
## Still some further cleaning is required: remove single letters/characters and removing digits. 


## DATA INSPECTION - WORDCLOUD
set.seed(100)
textplot_wordcloud(Z, min_count = 15, random_order = FALSE,
                   rotation = .25,
                   color = RColorBrewer::brewer.pal(8, "Dark2"))


## DECIDING THE WORDFISH BENCHMARK
## Considering the three candidate benchmarks obtained through sentiment analysis, frequency counts and the political left-right dimension (see primary R-file), it eventually was decided to benchmark the Wordfish estimation on the political left-right dimension.
## Benchmarking based on the political left-right dimension allows for the most intuitive interpretation of the Wordfish estimates. Moreover, it allows to directly test the obtained estimates for the presence of the expected political left-right pattern.
## The party from which manifesto contains most extracted text from respectively the GUE/NGL and ECR-group, function as the manifestos to which the Wordfish estimates are benchmarked.
## The parties associated with the ID are arguably more right-wing than the ECR, but because these parties typically take a populistic stance, they form less of stable/interpretable benchmark, it is thus opted to take a party affiliated to the ECR as upper boundary benchmark.
## This yields the following benchmark manifestos:
### GUE/NGL: "Parti du Travail de Belgique"
### ECR: "Nieuw-Vlaamse Aliantie"


## PART 4 - WORDFISH 
##WARNING
## The main advantage of the Quanteda package are its inbuilt graphing capabilities (compared to the TM package).
## HOWEVER, when working with Quanteda we experienced a (yet unresolved) problem in our script:
## The estimates produced differ from the estimates produced in the primary version.
results_2 <- textmodel_wordfish(Z, dir = c(21,16)) 
summary(results_2)
textplot_scale1d(results_2)

## PLOT "PSI" AGAINTS "BETA"
## Y-axis (psi) = word fixed effect
## X-axis (beta) = word specific weight capturing the importance of word "j" in discriminating between positions.
textplot_scale1d(results_2, margin = "features", 
                 highlighted = c("citi","region", "local", "subsidiar", "climat", "job","immigrat", "rural", "migrat", "energi", "municip", "agricultur", "work", "transport", "secur", "environ", "cohes", "infrastructur", "tourism", "solidar", "food", "educ", "brussel", "sport"))



## REFERENCES
## https://tutorials.quanteda.io/basic-operations/dfm/dfm_select/
## https://quanteda.io/articles/pkgdown/quickstart.html 
## https://tutorials.quanteda.io/machine-learning/wordfish/
## https://rdrr.io/github/quanteda/readtext/man/readtext.html
## https://cran.r-project.org/web/packages/quanteda/quanteda.pdf 
## https://cran.r-project.org/web/packages/quanteda/vignettes/quickstart.html
