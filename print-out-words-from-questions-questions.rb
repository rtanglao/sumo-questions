#!/usr/bin/env ruby
require 'rubygems'
require 'pp'
require 'csv'
require 'uea-stemmer'

f = File.open("stoplist.txt") or die "Unable to open stoplist.txt..."
stoplist = [] 
f.each_line {|line| stoplist.push line.chomp}

def cleanup(w, stoplist)
    w = w.delete(":\\-()[],;.!?'@#$%^&*<>/\"\\")
    return "" if w == ""
    return "" if w.length < 5
    w.downcase!
    return "" if stoplist.include?(w)
    return w
end
stemmer = UEAStemmer.new


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
    t = cleanup(title_word, stoplist)
    next if t == ""
    $stderr.printf("TITLE_WORD:%s\n",t)
    puts stemmer.stem(t)
  end
  content.split(" ").each do |content_word|
    c = cleanup(content_word, stoplist)
    next if c == ""
    puts stemmer.stem(c)
  end
end

