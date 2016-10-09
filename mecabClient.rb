class MecabClient

  # テキストを与えてインスタンスを生成
  def initialize(text)
    @text = text
  end

  # 単語ごとに分割した配列を返却する
  def to_words
    words = []
    result = `echo #{@text} | mecab -E "" | awk -F'\t' '{print $1}'`
    result.lines do |line|
      words.push line.chomp
    end
    return words
  end

  # テキストを与えると、単語とその品詞のハッシュを返却する
  def to_types
    words = {}
    result = `echo #{@text} | mecab -E "" | awk -F, '{print $1}'`
    result.each_line do |word|
      sp = word.chomp.split(/\s/)
      words[sp[0]] = sp[1]
    end
    return words
  end

end
