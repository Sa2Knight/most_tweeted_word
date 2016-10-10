class Tweets

  attr_reader :tweets

  # 全ツイート一覧CSVファイルのファイル名でインスタンスを生成
  def initialize(filename)
    @tweets = []
    File.foreach(filename) do |line|
      # CSVファイルから日付とツイート内容を取得
      columns = line.split(',').map {|c| c[1..-2]}
      next if columns[3].nil? or columns[5].nil?
      tweet = {:date => columns[3] , :tweet => columns[5]}
      # リプライ情報を抜き出す
      tweet[:to] = tweet[:tweet].scan(/(@[^ ^　]+).?/).to_a.flatten
      tweet[:to].each {|rp| tweet[:tweet].gsub!(rp , "")}
      # URLを抜き出す
      tweet[:attachmentURL] = tweet[:tweet].scan(%r|(https?://[\w/:%#\$&\?\(\)~\.=\+\-]+)|).to_a.flatten
      tweet[:attachmentURL].each {|au| tweet[:tweet].gsub!(au , "")}
      # ハッシュタグを抜き出す
      tweet[:hashtag] = tweet[:tweet].scan(%r|\s?(#[^ 　]+)\s?|).to_a.flatten
      tweet[:hashtag].each {|ht| tweet[:tweet].gsub!(ht , "")}
      @tweets.push(tweet)
    end
    @tweets.shift
  end

  # 日付文字列を指定し、それに当てはまるツイートのリストを戻す
  def search_date(date)
    @tweets.select {|t| t[:date].match(date)}
  end

  # テキストを指定し、それが含まれるツイートのリストを戻す
  def search_tweet(tweet)
    @tweets.select {|t| t[:tweet].match(tweet)}
  end

  # 全ツイートを戻す
  def all_tweets
    @tweets.map {|t| t[:tweet]}
  end

end
