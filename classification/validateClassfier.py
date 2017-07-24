# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 10:31:49 2017

@author: mcooper
"""

import os
import pandas as pd
import numpy as np

os.chdir('D:/Documents and Settings/mcooper/GitHub/mongolia-toponyms')

exec(open('ClassifierNaiveBayes.py', 'rb').read())

def accuracy(ct):
    N = ct.sum().sum()
    p0 = np.diag(ct).sum()/float(N)
    return(p0)

def kappa(ct):
    N = ct.sum().sum()
    p0 = np.diag(ct).sum()/float(N)
    pE = (1/float(N**2))*(ct.sum(axis=1)*ct.sum(axis=0)).sum()
    k = (p0 - pE)/(1 - pE)
    return(k)


def testOne(df, p=[0.8, 0.2], tok=1):
    df['sel'] = np.random.choice([1,2], df.shape[0], p=[0.8, 0.2])

    training = df.loc[df['sel']==1]
    test = df.loc[df['sel']==2]
    
    c = Classifier(training, tokens=tok)
    
    test[c.classes] = test['text'].apply(c.classify)
    test['max'] = test[c.classes].idxmax(axis=1)
    test = test[['max', 'class']].dropna()
    
    ct = pd.crosstab(test['class'], test['max'])
    
    for i in df['class'].unique():
        if i not in list(ct.columns.values):
            ct[i] = 0
              
    for i in df['class'].unique():
        if i not in list(ct.index):
            ct.loc[i] = 0
                  
    ct = ct.reindex_axis(sorted(ct.columns), axis=1)
    ct = ct.reindex_axis(sorted(ct.index), axis=0)
    
    return(ct)

def testAccuracy(df, p=[0.8, 0.2], tok=1, n=20):
    cts = []    
    for i in range(1,n): 
        print(i)
        cts.append(testOne(df, tok=tok, p=p))    
    
    return(sum(cts))

dat = pd.read_csv('data/inner_mongolia_sample_skp_classified.csv')

dat['text'] = dat['asciiname']

def f(row):
    if (row['zh'] == 'y') & (row['mn'] == 'y'):
        val = 'both'
    elif (row['zh'] =='y') & (row['mn'] == 'n'):
        val = 'chinese'
    elif (row['zh'] =='n') & (row['mn'] == 'n'):
        val = 'other'
    elif( row['zh'] =='n') & (row['mn'] == 'y'):
        val = 'mongolian'
    return val

dat['class'] = dat.apply(f, axis=1)

acc = testAccuracy(dat, tok=1, n=20)


kappa(acc)

accuracy(acc)
