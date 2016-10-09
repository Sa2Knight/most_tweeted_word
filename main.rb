# テキストを与えると、単語ごとに分割した配列を返却する
def text_to_words(text)
  words = []
  result = `echo #{text} | mecab -E "" | awk -F'\t' '{print $1}'`
  result.lines do |line|
    words.push line.chomp
  end
  return words
end

# テキストを与えると、単語ごとの出現回数をカウントする
def text_to_words_count(text)
  counts = Hash.new {|h , k| h[k] = 0}
  text.lines do |line|
    text_to_words(line.chomp).each do |w|
      counts[w] += 1
    end
  end
  return counts
end

# テキストを与えると、単語とその品詞のハッシュを返却する
# text_to_types("私は歩く") => {"私" => "名詞" , "は" => "助詞" , "歩く" => "動詞"} 
def text_to_types(text)
  words = {}
  result = `echo #{text} | mecab -E "" | awk -F, '{print $1}'`
  result.each_line do |word|
    sp = word.chomp.split(/\s/)
    words[sp[0]] = sp[1]
  end
  return words
end
