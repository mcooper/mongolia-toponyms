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

showMatch <- function(str, grams){
  match <- sapply(X=grams, FUN=grepl, x=str)
  paste(names(match)[match], collapse=';')
}

mon$asciiname <- tolower(mon$asciiname)
chn$asciiname <- tolower(chn$asciiname)

trans <- read.csv('transliterate.csv')
for(i in 1:nrow(trans)){
  mon$asciiname <- gsub(trans$mon[i], trans$inm[i], mon$asciiname)
}

mon_grams <- tableVectorNgrams(mon$asciiname, 3)
names(mon_grams)[2] <- 'mn_freq'
chn_grams <- tableVectorNgrams(chn$asciiname, 3)
names(chn_grams)[2] <- 'zh_freq'

all <- merge(mon_grams, chn_grams, by='gram', all=T)
all[is.na(all)] <- 0

write.csv(all, '../results/mn_zh_3grams.csv', row.names=F)

mon_sel <- all[all$mn_freq > all$zh_freq,]
chn_sel <- all[all$zh_freq > all$mn_freq,]

inm <- read.csv('inner_mongolia.csv')
inm$asciiname <- tolower(inm$asciiname)

inm$mon_sel <- sapply(X=inm$asciiname, FUN=countMatch, grams=mon_sel$gram)
inm$chn_sel <- sapply(X=inm$asciiname, FUN=countMatch, grams=chn_sel$gram)

inm$class[inm$chn_sel > inm$mon_sel] <- 'Chinese'
inm$class[inm$mon_sel > inm$chn_sel] <- 'Mongolian'
inm$class[inm$mon_sel == inm$chn_sel] <- 'Tie'

write.csv(inm, '../results/supervised2.csv', row.names=F)

##Add more detail

inm$mon_grams <- sapply(X=inm$asciiname, FUN=showMatch, grams=mon_sel$gram)
inm$chn_grams <- sapply(X=inm$asciiname, FUN=showMatch, grams=chn_sel$gram)

sar_val <- read.csv('inner_mongolia_sample_skp_classified.csv')
names(sar_val)[names(sar_val)!='geonameid'] <- paste0('sarala_', names(sar_val)[names(sar_val)!='geonameid'])

has_val <- read.csv('inner_mongolia_sample_to_validate_Has_classified_clean.csv')
names(has_val)[names(has_val)!='geonameid'] <- paste0('hasuntuya_', names(has_val)[names(has_val)!='geonameid'])

inm <- Reduce(function(x,y){merge(x,y,all.x=T,all.y=F)}, list(inm, sar_val, has_val))

write.csv(inm, '../results/supervised2_detailed.csv', row.names=F)


