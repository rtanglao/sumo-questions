#!/usr/bin/env ruby
require 'rubygems'
require 'pp'
require 'csv'

#$CSV.new(ARGF.file, :headers => true).each do |row|
# ARGF.each do |line|
#   if product != 1 break
#     if last_answerid == "NULL" break
#   #pp line.chomp
#   #double_quotes_changed_to_single_quotes = line.chomp.gsub("\"", "\'")
#   #CSV.parse(line.chomp, :headers => true) do |row|
#   pp line
# end
require 'csv'
CSV.foreach(ARGV[0], headers: true).with_index(1) do |row, ln|
  product_id = row['product_id'].to_i
  $stderr.puts("SKIPPING NON DESKTOP") if product_id != 1
  next if product_id != 1
  last_answer_id = row['last_answer_id']
  $stderr.puts("SKIPPING ANSWERED") if last_answer_id != "NULL"
  next if last_answer_id != "NULL"
  $stderr.puts '%s product_id:%s last_answer_id:%s title:%s content:%s' % [ln, *row.values_at('product_id', 'last_answer_id', 'title', 'content')]
  title = row['title']
  content = row['content']
  title.split(" ").each do |title_word|
    puts title_word.delete ":\\-()[],;.!?'@#$%^&*<>/\"\\"
  end
end

