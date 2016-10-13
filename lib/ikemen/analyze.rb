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
      #TODO: 修正が必要
      last_save(compareUser, @tweets.first)
    end

    ##############################
    # twitterのつぶやきから類似度のpointを返す
    ##############################
    def point_with_twitter_id(twitter_id)
      point = 0
      words = words(twitter_id, nil)
      #要素の出現回数をhashに記録
      count = array_count(words)
      #一致した単語を出現回数分掛け算する
      nouns = CompareNoun.where(noun: words.uniq)
      nouns.each do |val|
        point += count[val.noun] * val.point
      end
      point
    end

    #-------------------------private--------------------------------#
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
        analyze(@tweets)
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
        tweets
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
        tweets
      end

      #############################
      #条件に合う単語リストを返す
      #############################
      def analyze(tweets)
        worpheme = Morpheme.new(tweets)
        worpheme.words
      end

      #############################
      # 最後のtweetidを保管する
      #############################
      def last_save(user, tweet)
        return if tweet.nil?
        last_id = tweet.id.to_s
        user.update(last_tweet: last_id)
      end

      ##############################
      #hashで出現回数を数えておく
      ##############################
      def array_count(arr)
        result = Hash.new(0)
        arr.each do |word|
          result[word] += 1 
        end
        result
      end
  end
end

