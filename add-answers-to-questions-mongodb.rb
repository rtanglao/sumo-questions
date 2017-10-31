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
  # string fields have quotation marks at the beginning and end
  # in order to allow embedded commas, so have to remove them i guess?
  # time fields are pacific time and in string format, need to convert to utc
  # integers are strings
  # last field has a "\n" so use chomp to eliminate it?
 
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
  #id = row_hash["id"]
  #questionsColl.find({ 'id' => id }).update_one(
  #  row_hash,:upsert => true )

end
