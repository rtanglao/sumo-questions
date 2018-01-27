# sumo-questions
sumo questions: graphics, metrics and infoviz

## 26January2018 ##

* 1\. remove mongodb stdout logging with 

```ruby
Mongo::Logger.logger.level = ::Logger::FATAL # http://stackoverflow.com/questions/30292100/how-can-i-disable-mongodb-log-messages-in-console
```

* 2\. create firefox 55 title + content 1 word per line for the first 3 weeks of the release (FF55 releae dat was August 8, 2017

```bash
./get_firefox_desktop_words_by_start_stop_date.rb 2017 8 8 2017 8 28 > ff55.08August2017.28august2017.1st.3weeks.title.content.txt
```

## 17January2018 ##

* 1\. run mongodb

```bash
cd /Users/rtanglao/Dropbox/GIT/sumo-questions/MONGODB
mongod --config /usr/local/etc/mongod.conf --dbpath=. &
```

* 2\. fix firefox 55 and 56 desktop questions 

```bash
. setupMongo
cat SUMO-QUESTIONS_MYSQL_20OCT2017/ff55-56-question_questions.csv | ./add-questions-to-mongodb.rb 
```

* 3\. add firefox 57 desktop questions 

```bash
. setupMongo
cat SUMO_QUESTIONS_MYSQL_FF57_15DEC2017/ff57-questions_question.csv | ./add-questions-to-mongodb.rb 
```

## 21December2017 ##
### 21December2017-ff55-ff57

```bash
../print-out-words-from-questions-questions.rb ff57-questions_question.csv >ff57-unanswered-questions.txt
magic_cloud --textfile ff57-unanswered-questions.txt -f with-stopwords-ff57.jpg
```

### 21December2017-ff55-ff56

```bash
../print-out-words-from-questions-questions.rb ff55-56-question_questions.csv >ff55-ff56-unanswered-questions.txt
magic_cloud --textfile ff55-ff56-unanswered-questions.txt -f with-stopwords-ff55-ff56.jpg
```
## 16December2017 ##
* 1\. Setup magic_cloud, from https://stackoverflow.com/questions/22715738/imagemagick-error :
```bash
https://stackoverflow.com/questions/22715738/imagemagick-error
brew uninstall imagemagick@6 
brew install imagemagick@6 
PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig gem install rmagick
```

* 2\. make word cloud
```bash
../print-out-words-from-questions-questions.rb ff55-56-question_questions.csv >ff55-ff56-unanswered-questions.txt
magic_cloud --textfile ff55-ff56-unanswered-questions.txt -f naive-ff55-ff56.jpg
```

* 3\. Output
![Naive 55-56 wordcloud](https://raw.githubusercontent.com/rtanglao/sumo-questions/master/SUMO-QUESTIONS_MYSQL_20OCT2017/naive-ff55-ff56.jpg)

## 01November2017

* 1\. query to get Firefox unanswered questions CSV file (I used 3T MongoChef to run the query), result is in https://github.com/rtanglao/sumo-questions/blob/master/firefox_desktop_only_not_answered_in_72hours_id_created.csv :
```mongo
db.questions.find({"product_id":1, "answered_in_72_hours":false}, {"id":1, "created":1, "_id":0})
```
## 31October2017

* 1\. compute ```answered_in_72_hours``` boolean
```bash
./add-answered-in-72-hours.rb 2>stderr_add_answered.txt
```

## 30October2017
### 30October2017-more data cleaning
Also change:
* 1\. ```change "" to ","```
* 2\. truncate the content field (it seems like the built-in CSV built-in parser can't handle >256 characters and SUMO troubleshooting info can be very large i.e. 1024 characters or larger

### 30October2017-first-run-of-adding-answers aka replies
```bash
cat SUMO-QUESTIONS_MYSQL_20OCT2017/questions_answers.csv | 
./add-answers-to-questions-mongodb.rb
```
## 29October2017
* 0\. But first in question_questions.csv (hooray for quoting :-) !):
    * ```change "\"" to "\'"```
    * ```change "\\'", to ' "'```
* 1\. add questions to mongodb

```bash
. setupMongo
cat SUMO-QUESTIONS_MYSQL_20OCT2017/question_questions.csv | ./add-questions-to-mongodb.rb 
```
## 19october2017
* 1\. run mongodb
```bash
cd /Users/rtanglao/Dropbox/GIT/sumo-questions/MONGODB
mongod --config /usr/local/etc/mongod.conf --dbpath=. &
```
