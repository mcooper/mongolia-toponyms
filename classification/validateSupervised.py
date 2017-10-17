import os
import pandas as pd
import numpy as np

os.chdir('D:/Documents and Settings/mcooper/GitHub/mongolia-toponyms')

#######################
#read in and clean validation data
######################
valid = pd.read_csv('data/inner_mongolia_sample_skp_classified.csv')
valid['text'] = valid['asciiname']
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
valid['true_class'] = valid.apply(f, axis=1)
del valid['asciiname']

##Read in model results
result = pd.read_csv('results/supervised2.csv')


comb = valid.merge(result, on=['geonameid'])

ct = pd.crosstab(comb['class'], comb['true_class'])

f = open('crosstab.txt', 'w')
f.write(str(ct))
f.close()