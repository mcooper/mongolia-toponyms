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

tableVectorNgrams <- function(vect, size=3){
  vect <- tolower(vect)
  
  vect <- sapply(vect, makeLastUpper)
  
  vect <- gsub("[^[:lower:] ]", "", vect)

  nGrams <- sapply(vect, getWordNGrams, n=size) %>% 
    unlist %>%
    table
  
  df <- data.frame(gram=names(nGrams), freq=as.vector(nGrams/sum(nGrams)))
  
  return(df)
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

mon_grams <- tableVectorNgrams(mon$asciiname, 3)
chn_grams <- tableVectorNgrams(chn$asciiname, 3)

all <- merge(mon_grams, chn_grams, by='gram', all=T)
all[is.na(all)] <- 0

mon_sel <- all[all$freq.x > all$freq.y,]
chn_sel <- all[all$freq.y > all$freq.x,]
names(mon_sel) <- c('gram', 'mon_freq', 'chn_freq')

inm <- read.csv('inner_mongolia.csv')
inm$asciiname <- tolower(inm$asciiname)

inm$mon_sel <- sapply(X=inm$asciiname, FUN=countMatch, grams=mon_sel)
inm$chn_sel <- sapply(X=inm$asciiname, FUN=countMatch, grams=chn_sel)

inm$class[inm$chn_sel > inm$mon_sel] <- 'Chinese'
inm$class[inm$mon_sel > inm$chn_sel] <- 'Mongolian'
inm$class[inm$mon_sel == inm$chn_sel] <- 'Tie'

write.csv(inm, '../results/supervised2.csv', row.names=F)








