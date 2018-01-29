#!/usr/local/bin/python3
import nltk, re, pprint
from nltk import word_tokenize
from nltk import bigrams, trigrams
import fileinput
raw = ""
for line in fileinput.input():
    raw += line.rstrip()
    raw += ' '
tokens = word_tokenize(raw)
tokens_bigrams = bigrams(tokens)
print (list(tokens_bigrams))

#list(ngrams(tokens_bigrams, 4))
