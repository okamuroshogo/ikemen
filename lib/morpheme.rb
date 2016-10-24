require "uri"

class Morpheme

  #品詞-> part of speech (複数形 parts of speech)
  WHITE_PSOS = ["名詞","形容詞"]
  BLACK_PSOS = []
  #個別に条件を指定したいワードリスト
  WHITE_WORDS = []
  BLACK_WORDS = []
  #ツイート文で置換しておきたい正規表現リスト
  SPASE_REGEXP = /(^.*[[:space:]])*/
#  @@HALF_SYMBOLE = "\\p{Punct}" #半角記号
#  @@FULL_SYMBOLE = "！”＃＄％＆’（）＝～｜‘｛＋＊｝＜＞？＿－＾￥＠「；：」、。・" #全角記号
  UNICODE_REGEXP = /(^.*[\u0080-\u009F])*/
  REGEXP_LIST = [URI.regexp, SPASE_REGEXP, UNICODE_REGEXP]

  ########################
  # initialyzer(TEETOBJ)
  ########################
  def initialize(words)
    return if words.nil?
    @words = analyze(words)
  end 

  #######################
  # getter
  #######################
  def words
    @words
  end

  private
    ########################
    #　tweetを置換する
    ########################
    def tweet_replacement(tweet)
      str = tweet
      REGEXP_LIST.each do |regexp|
        str = str.gsub(regexp, "")
      end
      str
    end

    ###########################
    # ツイートリストから条件にしたがって単語を取り出す
    ###########################
    def analyze(tweets)
      result = []
      tweets.each do |tweet|
        full_text = tweet_replacement(tweet.full_text)
        result.concat(morpheme(full_text))
      end
      result
    end

    ############################
    # Kuromojiライブラリを使いtextを形態素解析する
    ############################
    def morpheme(text)
      nouns = []
      Kuromoji.tokenize(text).each do |kuromoji_array|
        kuromoji_array.each do |pos_array|
          kuromoji_filter(pos_array) == true ? next : nouns << kuromoji_array[0]
        end
      end
      nouns
    end

    #############################
    # 品詞が含まれる配列を条件で分類する trueでスキップ
    #############################
    def kuromoji_filter(pos_array)
      pos_array.split(",").each_with_index do |pos_and_word,i|
        return true if (i == 0 ? word_filter?(pos_and_word) : pos_filter?(pos_and_word))
      end
    end

    #############################
    # 抽出する品詞の条件を指定 true でスキップ
    #############################
    def pos_filter?(pos)
      #ブラックリスト
      return true if black_pos?(pos) 
      #ホワイトリスト
      return false if white_pos?(pos) 
      #それ以外
      return true
    end
    #############################
    # 抽出する単語の条件を指定 true でスキップ
    #############################
    def word_filter?(word)
      #単語の文字数を制限
      return true if word.length < 2
      #ブラックリスト
      return true if black_word?(word) 
      #ホワイトリスト
      return false if white_word?(word) 
      #それ以外
      return false
    end
    #############################
    # 品詞のホワイトリストに含まれていたらtrue
    #############################
    def white_pos?(word)
      search_list(WHITE_PSOS,word)
    end

    #############################
    # 品詞のブラックリストに含まれていたらtrue
    #############################
    def black_pos?(word)
      search_list(BLACK_PSOS,word)
    end

    #############################
    # 単語のホワイトリストに含まれていたらtrue
    #############################
    def white_word?(word)
      search_list(BLACK_WORDS,word)  
    end

    #############################
    # 単語のブラックリストに含まれていたらtrue
    #############################
    def black_word?(word)
      search_list(BLACK_WORDS,word)
    end

    #############################
    #リストに含まれていたらtrue
    ############################
    def search_list(lists, elm)
      lists.any?{|obj| elm.match(/^#{obj}/) }
    end
end

