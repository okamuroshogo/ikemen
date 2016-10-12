module Analyze
  class << self

    #############################
    #twitterから単語を抽出しConpareNounsに種データを追加する
    #############################
    def glow_compare_nouns(compareUser)
      words = words_with_twitter_id(compareUser.twitter_id)
      words.each do |word|
        compareNoun = CompareNoun.find_or_initialize_by(noun: word)
        #得点処理
        compareNoun.point = compareNoun.point + compareUser.weight
        #compareNoun.point.to_i += compareUser.weight
        compareNoun.save

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
      def words_with_twitter_id(twitter_id)
        tweets = tweet_list(twitter_id)
        words = analyze(tweets)
        return words
      end

      #############################
      # twitter_idからツイートリストを取得
      #############################
      def tweet_list(twitter_id)
        tweets = []
        ##TODO twitterIDが存在しない時にエラーになる
        Config::CLIENT.user_timeline(twitter_id).each do |tweet| 
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
  end
end

