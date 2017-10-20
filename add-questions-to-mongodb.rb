#!/usr/bin/env ruby
require 'rubygems'
require 'pp'
require 'json'
require 'time'
require 'date'
require 'mongo'

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

first = true
ARGF.each do |line|
  if first
    first = false
    pp line
    next
  end
  pp line.split(",")
  pp line.split(",")[2]
  puts line.split(",")[2]
  puts line.split(",")[8]
  exit
end
