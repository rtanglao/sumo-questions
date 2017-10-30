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

CSV.new(ARGF.file, :headers => true).each do |row|
  # string fields have quotation marks at the beginning and end
  # in order to allow embedded commas, so have to remove them i guess?
  # time fields are pacific time and in string format, need to convert to utc
  # integers are strings
  # last field has a "\n" so use chomp to eliminate it?
 
  PP::pp(row, $stderr)
  

  # "id" - 0 
  # "title" - 1
  # "creator_id" - 2
  # "content" - 3
  # "created" - 4
  # "updated" - 5
  # "updated_by_id" - 6
  # "last_answer_id" - 7
  # "num_answers", - 8
  # "is_locked" - 9
  # "solution_id" - 10
  # "num_votes_past_week" 11,"locale" 12,"is_archived"13,"is_spam"14
  # ,"marked_as_spam"15,"marked_as_spam_by_id"16,"product_id"17,"topic_id"18
  # ,"taken_by_id"19,"taken_until"20
  row_hash = {}
  row_hash["id"] = row["id"].to_i
  row_hash["title"] = row["title"]
  row_hash["creator_id"] = row["creator_id"].to_i
  row_hash["content"] = row["content"]
  row_hash["created"] = Time.parse(row["created"])
  row_hash["updated"] = Time.parse(row["updated"])
  row_hash["updated_by_id"] =
    row["updated_by_id"] =="NULL" ? nil : row["updated_by_id"]
  row_hash["last_answer_id"] =
    row["last_answer_id"] == "NULL" ? nil : row["last_answer_id"].to_i
  row_hash["num_answers"] = row["num_answers"].to_i
  row_hash["is_locked"] = row["is_locked"] == "0" ? false : true
  row_hash["solution_id"] = 
      row["solution_id"] == "NULL" ? nil : row["solution_id"].to_i
  row_hash["num_votes_past_week"] = row["num_votes_past_week"].to_i
  row_hash["locale"] = row["locale"]
  row_hash["is_archived"] = row["is_archived"] == "0" ? false : true
  row_hash["is_spam"] = row["is_spam"] == "0" ? false : true
  row_hash["product_id"] = row["product_id"].to_i
  row_hash["topic_id"] = row["topic_id"].to_i
  PP::pp(row_hash, $stderr)
  id = row_hash["id"]
  questionsColl.find({ 'id' => id }).update_one(
    row_hash,:upsert => true )

end
