#!/usr/bin/env ruby
require 'rubygems'
require 'pp'
require 'json'
require 'time'
require 'date'
require 'mongo'
require 'CSV'

# based on:
# https://github.com/rtanglao/2016-rtgram/blob/master/backupPublicVancouverPhotosByDateTaken.rb

MONGO_HOST = ENV["MONGO_HOST"]
raise(StandardError,"Set Mongo hostname in ENV: 'MONGO_HOST'") if !MONGO_HOST
MONGO_PORT = ENV["MONGO_PORT"]
raise(StandardError,"Set Mongo port in ENV: 'MONGO_PORT'") if !MONGO_PORT
MONGO_USER = ENV["MONGO_USER"]
# raise(StandardError,"Set Mongo user in ENV: 'MONGO_USER'") if !MONGO_USER
MONGO_PASSWORD = ENV["MONGO_PASSWORD"]
# raise(StandardError,"Set Mongo user in ENV: 'MONGO_PASSWORD'") if !MONGO_PASSWORD
QUESTIONS_DB = ENV["QUESTIONS_DB"]
raise(StandardError,\
      "Set Mongo instagram database name in ENV: 'QUESTIONS_DB'") \
  if !QUESTIONS_DB

db = Mongo::Client.new([MONGO_HOST], :database => QUESTIONS_DB)
if MONGO_USER
  auth = db.authenticate(MONGO_USER, MONGO_PASSWORD)
  if !auth
    raise(StandardError, "Couldn't authenticate, exiting")
    exit
  end
end

questionsColl = db[:questions]
questionsColl.indexes.create_one({ "id" => -1 }, :unique => true)

CSV.new(ARGF.file, :headers => true,
        :force_quotes => true
       ).each do |row|
 
  PP::pp(row, $stderr)

  # "id", "question_id","creator_id","created","content","updated","updated_by_id","upvotes","page","is_spam","marked_as_spam","marked_as_spam_by_id"

  row_hash = {}
  row_hash["answer_id"] = row["id"].to_i
  question_id = row["question_id"].to_i
  
  row_hash["answer_creator_id"] = row["creator_id"].to_i
  row_hash["answer_created"] = Time.parse(row["created"])
  row_hash["answer_content"] = row["content"]
 
  row_hash["answer_updated"] = row["updated"] == "NULL" ? nil : Time.parse(row["updated"])
  row_hash["answer_updated_by_id"] =
    row["updated_by_id"] =="NULL" ? nil : row["updated_by_id"].to_i
  row_hash["upvotes"] =
    row["upvotes"] == "NULL" ? 0 : row["upvotes"].to_i
  row_hash["page"] = row["page"].to_i
  row_hash["is_spam"] = row["is_spam"] == "0" ? false : true
  row_hash["marked_as_spam"] =
    row["marked_as_spam"] == "NULL" ? false : true
 row_hash["marked_as_spam_by_id"] =
   row["marked_as_spam_by_id"] == "NULL" ? false :
     row["marked_as_spam_by_id"].to_i
  PP::pp(row_hash, $stderr)
 
  question = questionsColl.find({ "id" => question_id}).\
               projection({ "id" => 1, "answers" => 1}).limit(1).first()
  begin $stderr.printf("can't find question:%d\n", question_id) ; next
  end if question.nil?
  pp question["id"]
  pp question["answers"]
  answers = []
  if question["answers"].nil?
    $stderr.printf("answers is NIL, adding row hash\n")
  else
    $stderr.printf("answers NOT NIL, deleting old answer\n")
    answers.delete_if{|answer|
      answer["answer_id"] == row_hash["answer_id"]}    
  end
  answers.push(row_hash)
  $stderr.printf("UPDATING answers to:\n")
  PP::pp(answers, $stderr)
  questionsColl.find_one_and_update(
       { id: question_id }, { "$set" => { answers: answers }},
       :upsert => true)
end
