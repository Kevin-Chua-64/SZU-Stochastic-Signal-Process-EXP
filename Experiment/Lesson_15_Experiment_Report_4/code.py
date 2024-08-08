from urllib.request import urlopen
from random import randint

def wordListSum(wordList):
    # Total sum of the words next
    sum = 0
    for word, value in wordList.items():
        sum += value
    return sum

def retrieveRandomWord(wordList):
    # Create a random number to select the word
    randIndex = randint(1, wordListSum(wordList))
    for word, value in wordList.items():
        randIndex -= value
        if randIndex <= 0:
            return word

def buildWordDict(text):
    # Replace line breaks with blank and remove quotes
    text = text.replace('\n', ' ')
    text = text.replace('"', '')
    # Replace punctuations with blank
    punctuation = [',', '.', ';', ':']
    for symbol in punctuation:
        text = text.replace(symbol, ' {} '.format(symbol))
    
    # Split the words with blank
    words = text.split(' ')
    # Filter out empty words
    words = [word for word in words if word != '']

    # Create a word dictionary base on the text
    wordDict = {}
    for i in range(1, len(words)):
        if words[i-1] not in wordDict:
            # Create a new dictionary for this word
            wordDict[words[i-1]] = {}
        if words[i] not in wordDict[words[i-1]]:
            # Create a key of the word that after the word[i-1]
            wordDict[words[i-1]][words[i]] = 0
        wordDict[words[i-1]][words[i]] += 1
    return wordDict

# Load a txt using Web-crawler
text = str(urlopen('http://pythonscraping.com/files/inaugurationSpeech.txt')
          .read(), 'utf-8')
# Bulid a word dictionary base on the text
wordDict = buildWordDict(text)

# Generate a 100-word text beginning with I using Markov chain 
length = 100
chain = ['I']
for i in range(0, length):
    newWord = retrieveRandomWord(wordDict[chain[-1]])
    chain.append(newWord)

print(' '.join(chain))