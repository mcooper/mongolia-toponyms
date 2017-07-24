import pandas as pd
from collections import defaultdict
import re

class Classifier:
    def __init__(self, training_data, tokens=1):
        self.tokens=tokens
        self.training_data = training_data.dropna()
        self.classes = self.training_data['class'].unique()
        self.freq_df = self._createFreqTab(training_data)
        self.totals = self.freq_df.sum()
        self.probs = self.totals/self.totals.sum()    
    
    def _createFreqTab(self, training_data):
        '''Requires a data frame with two columns:
                1. 'text' which is the text of toponyms
                2. 'class' which is the categories that each toponym falls into
            
           Returns a data frame with a column for each category and rows for each word'''
    
        #Get wordcounts for each class
        dicts = []
        for c in self.classes:
            lines = training_data.loc[training_data['class'] == c, 'text']
            masterdict = defaultdict(int)
            for l in lines:
                words = self.tokenize(l)
                for w in set(words):
                    if w=='rt':
                        pass
                    elif w[:4]=='http':
                        masterdict['http'] += 1
                    else:
                        masterdict[w] += 1
            dicts.append(masterdict)
        
        #Create a frequency table for all words
        freq_df = pd.DataFrame(dicts).T
        freq_df.columns = self.classes
        
        freq_df = freq_df.fillna(0.1)
        
        return(freq_df)
    
    def classify(self, toponym):
        '''Requires a toponym
            
           Returns a pandas series of the likelihood of the toponym falling into each category'''
    
        wds = self.tokenize(toponym)
        words = self.freq_df.ix[wds, ]
        f = (words/self.totals).product()
        likelihood = f*self.probs
        likelihood_rel = likelihood/likelihood.sum()

        return(likelihood_rel)
    
    def tokenize(self, toponym):
        toponym = toponym.lower()
        grams = []
        for i in range(0,len(toponym)-2):
            gram = toponym[i:i+3]
            grams.append(gram)
        return(set(grams))





        
        