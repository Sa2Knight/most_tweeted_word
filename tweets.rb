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
      tweet[:reply_to] = tweet[:tweet].scan(/(@\w+)/).flatten
      tweet[:reply_to].each {|rp| tweet[:tweet].gsub!(rp , "")}
      # URLを抜き出す
      tweet[:attachment_url] = tweet[:tweet].scan(%r|(https?://[\w/:%#\$&\?\(\)~\.=\+\-]+)|).flatten
      tweet[:attachment_url].each {|au| tweet[:tweet].gsub!(au , "")}
      # ハッシュタグを抜き出す
      tweet[:hash_tag] = tweet[:tweet].scan(%r|\s?(#[^ 　]+)\s?|).flatten
      tweet[:hash_tag].each {|ht| tweet[:tweet].gsub!(ht , "")}
      @tweets.push(tweet)
    end
    @tweets.shift
  end

  # リプライ率を計算する
  def reply_late
    reply_tweet = @tweets.select {|t| ! t[:reply_to].empty?}
    return reply_tweet.count.to_f / @tweets.count.to_f * 100
  end

  # リプライ対象ユーザのランキングを生成する
  def reply_ranking
    users = Hash.new {|h , k| h[k] = 0}
    reply = @tweets.map {|t| t[:reply_to]}.select {|t| t.size > 0}
    reply.each {|r| r.each {|user| users[user] += 1}}
    return users.sort {|(k1 , v1) , (k2 , v2)| v2 <=> v1}
  end

  # 日付文字列を指定し、それに当てはまるツイートのリストを戻す
  def search_date(date)
    @tweets.select {|t| t[:date].match(date)}
  end

  # テキストを指定し、それが含まれるツイートのリストを戻す
  def search_tweet(tweet)
    @tweets.select {|t| t[:tweet].match(tweet)}
  end

  # ユーザ名を指定し、それが含まれるリプライツイートのリストを戻す
  def search_reply(user)
    @tweets.select {|t| t[:reply_to].include?("@" + user)}
  end

  # 全ツイートを戻す
  def all_tweets
    @tweets.map {|t| t[:tweet]}
  end

end
