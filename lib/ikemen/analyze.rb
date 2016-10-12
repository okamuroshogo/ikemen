module Analyze
  class << self

    #############################
    #twitterから単語を抽出しConpareNounsに種データを追加する
    #############################
    def setCompareNouns(compareUser)
      words = getWordsWithTwitterId(compareUser.twitter_id)
      words.each do |word|
#        CompareNoun.where(noun: word).first_or_create do |compareNoun|
          #compareNoun.increment(:point)
#        end
        compareNoun = CompareNoun.find_or_initialize_by(noun: word)
        #得点処理
        compareNoun.point = compareNoun.point + compareUser.weight.to_i
        #compareNoun.point.to_i += compareUser.weight
        compareNoun.save

      end
    end

    ##############################
    # twitterのつぶやきから類似度を算出
    ##############################
    def getPointWithTwitterid(twitter_id)
      words = getWordsWithTwitterId(twitter_id)
      words.each do |word|
        #TODO:得点算出と検索
      end
    end

    private

      #############################
      # twitter_idから条件に合う単語リストを取得
      #############################
      def getWordsWithTwitterId(twitter_id)
        tweets = getTweet(twitter_id)
        words = analyze(tweets)
        return words
      end

      #############################
      # twitter_idからツイートリストを取得
      #############################
      def getTweet(twitter_id)
        tweets = []
        p "==================================="
        p twitter_id
        p "==================================="

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
        result = []
        
        
        #TODO classに切り出す
        #条件はホワイトリストとブラックリスト
        white_list = ["名詞","形容詞"]
        black_list = []

        tweets.each do |tweet|
          Kuromoji.tokenize(tweet.full_text).each do |noun| 
           noun.each do |pos|
              pos.split(",").each_with_index do |word,index|
                #単語は１文字だけの場合も排除
                p noun
                next if !search_list(white_list, word) || word.length < 2
                #p noun[0]
                result << noun[0]
                break
              end
            end
          end
        end
        return result
      end

      #############################
      #リストに含まれていたらtrue
      ############################
      def search_list(lists, elm)
        result = false
        lists.each do |obj|
          result = true if elm.match(/^#{obj}/)
        end
        return result
      end

  end
end

