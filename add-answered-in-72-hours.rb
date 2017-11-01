#!/usr/bin/env ruby
require 'rubygems'
require 'pp'
require 'json'
require 'time'
require 'date'
require 'mongo'

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
questionsColl.find().projection({
                                  "id" => 1,
                                  "answers" => 1,
                                  "creator_id" => 1,
                                  "created" => 1,
                                  "answered_in_72_hours" => 1
                                }).each do |q|
  answered_in_72_hours = q["answered_in_72_hours"].nil? ? false : q["answered_in_72_hours"]
  $stderr.printf("FROM MONGODB answered_in_72_hours:%s\n",  answered_in_72_hours)

  creator_id = q["creatorid"]
  created = q["created"].to_i
  answers = q["answers"].to_a #A mongodb array is a cursor not a ruby array so convert to ruby array
  PP::pp(q, $stderr)
  if answers != []
    answered_in_72_hours = answers.any?{|a|
      a["answer_creator_id"] != creator_id &&
        a["answer_created"].to_i - created <= 60 * 60 * 24 * 3 # 72 hours
    }
  end 
  $stderr.printf("SETTING answered_in_72_hours to:%s\n",  answered_in_72_hours)
  questionsColl.find_one_and_update(
    { id: q["id"] }, { "$set" => { answered_in_72_hours: answered_in_72_hours }},
    :upsert => true)
 end
