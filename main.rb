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
