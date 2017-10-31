# sumo-questions
sumo questions: graphics, metrics and infoviz
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
