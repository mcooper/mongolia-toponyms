setwd('D://Documents and Settings/mcooper/GitHub/mongolia-toponyms/data/')

options(stringsAsFactors = F)

library(dplyr)

mon <- read.csv('mongolia.csv')
chn <- read.csv('china_homeland.csv')

indexCapitalize <- function(str, index){
  if (index==1){
    end <- substr(str, index+1, nchar(str))
    chr <- substr(str, index, index)
    newStr <- paste0(toupper(chr), end)
  }
  else if (index==nchar(str)){
    begin <- substr(str, 1, index-1)
    chr <- substr(str, index, index)
    newStr <- paste0(begin, toupper(chr))
  }
  else{
    begin <- substr(str, 1, index-1)
    end <- substr(str, index+1, nchar(str))
    chr <- substr(str, index, index)
    newStr <- paste0(begin, toupper(chr), end)
  }
  return(newStr)
}

makeLastUpper <- function(str){
  newStr <- indexCapitalize(str, nchar(str))
  ind <- c(gregexpr(pattern=' ', str)[[1]]-1)
  for (i in ind){
    newStr <- indexCapitalize(newStr, i)
  }
  return(newStr)
}

getWordNGrams <- function(str, n){
  len <- nchar(str)
  mapply(substr, start=1:(len-(n-1)), stop=n:len, x=str)
}

getVectorNgrams <- function(vect, size=3){
  vect <- tolower(vect)
  
  vect <- sapply(vect, makeLastUpper)
  
  vect <- gsub("[^[:lower:] ]", "", vect)

  nGrams <- sapply(vect, getWordNGrams, n=size) %>% 
    unlist %>%
    unique
  
  return(nGrams)
}

countMatch <- function(str, grams){
  sum(sapply(X=grams, FUN=grepl, x=str))
}

mon$asciiname <- tolower(mon$asciiname)
chn$asciiname <- tolower(chn$asciiname)

trans <- read.csv('transliterate.csv')
for(i in 1:nrow(trans)){
  mon$asciiname <- gsub(trans$mon[i], trans$inm[i], mon$asciiname)
}

mon_grams <- getVectorNgrams(mon$asciiname, 3)
chn_grams <- getVectorNgrams(chn$asciiname, 3)

mon_sel <- mon_grams[!mon_grams %in% chn_grams]
chn_sel <- chn_grams[!chn_grams %in% mon_grams]

inm <- read.csv('inner_mongolia.csv')
inm$asciiname <- tolower(inm$asciiname)

inm$mon_grams <- sapply(X=inm$asciiname, FUN=countMatch, grams=mon_grams)
inm$chn_grams <- sapply(X=inm$asciiname, FUN=countMatch, grams=chn_grams)
inm$mon_sel <- sapply(X=inm$asciiname, FUN=countMatch, grams=mon_sel)
inm$chn_sel <- sapply(X=inm$asciiname, FUN=countMatch, grams=chn_sel)

inm$class[inm$chn_grams > inm$mon_grams & inm$chn_sel > inm$mon_sel] <- 'Chinese'
inm$class[inm$mon_grams > inm$chn_grams & inm$mon_sel > inm$chn_sel] <- 'Mongolian'
inm$class[inm$mon_grams == inm$chn_grams & inm$mon_sel == inm$chn_sel] <- 'Tie'

write.csv(inm, '../results/supervised.csv', row.names=F)








