require_relative 'tweets'
require_relative 'mecabClient'
require 'pp'

# テキストの配列を与えると、単語ごとの出現回数を戻す
def texts_to_words_count(texts , type)
  counts = Hash.new {|h , k| h[k] = 0}
  texts.each do |t|
    MecabClient.new(t.chomp).to_words(type).each do |w|
      counts[w] += 1
    end
  end
  return counts
end

tweets = Tweets.new('tweets.csv').all_tweets
texts_to_words_count(tweets , '名詞 一般').select {|k , v| k.size >= 2 && v >= 2}.sort {|(k1,v1),(k2,v2)| v2 <=> v1}.each_with_index do |n , i|
  p "#{i + 1}位 #{n[0]} #{n[1]}回"
end
