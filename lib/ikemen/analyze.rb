module Analyze
  class << self

    #############################
    #twitterから単語を抽出しConpareNounsに種データを追加する
    #############################
    def glow_compare_nouns(compareUser)
      words = words(compareUser.twitter_id, compareUser.last_tweet)
      words.each do |word|
        compareNoun = CompareNoun.find_or_initialize_by(noun: word)
        #得点処理
        compareNoun.update(point: compareNoun.point + compareUser.weight)

      end
      last_save(compareUser, @tweets.first)
    end

    ##############################
    # twitterのつぶやきから類似度を算出
    ##############################
    def point_with_twitter_id(twitter_id)
      point = 0
      words = words(twitter_id, nil)
      words.each do |word|
        #TODO:得点算出と検索
        noun = CompareNoun.find_by(noun: word) 
        next if noun.nil?
        point += noun.point
      end
      p "QQQQQQQQQQQQQQQQQQQQ"
      p point
      return point
    end

    private

      #############################
      # twitter_idから条件に合う単語リストを取得
      #############################
      def words(twitter_id, last_tweet)
        #最後のtweet_idがなければ過去から全て取得してくる
        if last_tweet.nil?
          @tweets = tweets(twitter_id)
        else
          @tweets = tweets_with_last_date(twitter_id, last_tweet)
        end
        return analyze(@tweets)
      end

      #############################
      # twitter_idからツイートリストを取得
      #############################
      def tweets(twitter_id)
        tweets = []
        ##TODO twitterIDが存在しない時にエラーになる
        ##TODO 鍵アカウントもエラーになる
        Config::CLIENT.user_timeline(twitter_id).each do |tweet| 
          tweets << tweet
        end
        return tweets
      end

      #############################
      # twitter_idから最後のtweetid以降のツイートリストを取得
      # (tweetid , last_tweet_id)  -> [tweet]
      #############################
      def tweets_with_last_date(twitter_id, last_date)
        tweets = []
        ##TODO twitterIDが存在しない時にエラーになる
        Config::CLIENT.user_timeline(twitter_id, { since_id: last_date }).each do |tweet| 
          tweets << tweet
        end
        return tweets
      end

      #############################
      #条件に合う単語リストを返す
      #############################
      def analyze(tweets)
        worpheme = Morpheme.new(tweets)
        return worpheme.words

      end

      #############################
      # 最後のtweetidを保管する
      #############################
      def last_save(user, tweet)
        return if tweet.nil?
        last_id = tweet.id.to_s
        user.update(last_tweet: last_id)
      end

  end
end

