# sumo-questions
sumo questions: graphics, metrics and infoviz
## 29October2017
* 0\. But first in question_questions.csv (hooray for quoting :-) !):
    * ```change "\"" to "\'"```
    * ```change "\\'", to ' "'```
* 1\. add questions to mongodb

```bash
cat SUMO-QUESTIONS_MYSQL_20OCT2017/question_questions.csv | ./add-questions-to-mongodb.rb 
```
## 19october2017
* 1\. run mongodb
```bash
cd /Users/rtanglao/Dropbox/GIT/sumo-questions/MONGODB
mongod --config /usr/local/etc/mongod.conf --dbpath=. &
```
