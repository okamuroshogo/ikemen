module Analyze
  class << self

    #############################
    #twitterから単語を抽出しConpareNounsに種データを追加する
    #############################
    def glow_compare_nouns(compareUser)
      words = words(compareUser)
      words.each do |word|
        compareNoun = CompareNoun.find_or_initialize_by(noun: word)
        #得点処理

        #TODO 1行でupdateできるはず saveとかいらんとおもう
#        compareNoun.point = compareNoun.point + compareUser.weight
        #compareNoun.point.to_i += compareUser.weight
#        compareNoun.save
        compareNoun.update(point: compareNoun.point + compareUser.weight)

      end
    end

    ##############################
    # twitterのつぶやきから類似度を算出
    ##############################
    def point_with_twitter_id(twitter_id)
      words = words_with_twitter_id(twitter_id)
      words.each do |word|
        #TODO:得点算出と検索
      end
    end

    private

      #############################
      # twitter_idから条件に合う単語リストを取得
      #############################
      def words(user)
        #最後のtweet_idがなければ過去から全て取得してくる
        if user.last_tweet.nil?
          @tweets = tweets(user.twitter_id)
        else
          @tweets = tweets_with_last_date(user.twitter_id, user.last_tweet)
        end

        last_save(user, @tweets.first)

        words = analyze(@tweets)
        return words
      end

      #############################
      # twitter_idからツイートリストを取得
      #############################
      def tweets(twitter_id)
        tweets = []
        ##TODO twitterIDが存在しない時にエラーになる
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

