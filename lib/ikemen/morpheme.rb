require "uri"

class Morpheme

  #品詞-> part of speech (複数形 parts of speech)
  @@WHITE_PSOS = ["名詞","形容詞"]
  @@BLACK_PSOS = []
  #個別に条件を指定したいワードリスト
  @@WHITE_WORDS = []
  @@BLACK_WORDS = []

  ########################
  # initialyzer
  ########################
  def initialize(words)
    @words = analyze(words)
  end 

  #######################
  # getter
  #######################
  def words
    return @words
  end

  private
    ########################
    #　URLを置換する
    ########################
    def url_replacement(str)
      return str.gsub(URI.regexp, "")
    end

    ###########################
    # ツイートリストから条件にしたがって単語を取り出す
    ###########################
    def analyze(tweets)
      #TODO !!result
      @result = []
      tweets.each do |tweet|
        full_text = url_replacement(tweet.full_text)
        morpheme(full_text)
      end
      return @result
    end

    ############################
    # Kuromojiライブラリを使いtextを形態素解析する
    ############################
    def morpheme(text)
      Kuromoji.tokenize(text).each do |noun|
        noun.each do |pos|
          pos_filter(pos,noun)
        end
      end
    end

    #############################
    # 品詞が含まれる配列を条件で分類する
    #############################
    def pos_filter(pos,noun)
      pos.split(",").each_with_index do |word,index|
        next if word_filter?(word)
        p noun[0]
        @result << noun[0]
        break
      end
    end

    #############################
    # 抽出する単語の条件を指定 true でスキップ
    #############################
    def word_filter?(word)
      #文字制限
      return true if word.length < 2
      #ブラックリスト
      return true if black_pos?(word) || black_word?(word)
      #ホワイトリスト
      return false if white_pos?(word) || white_word?(word)
      #それ以外
      return true
    end
    #############################
    # 品詞のホワイトリストに含まれていたらtrue
    #############################
    def white_pos?(word)
      search_list(@@WHITE_PSOS,word)
    end

    #############################
    # 品詞のブラックリストに含まれていたらtrue
    #############################
    def black_pos?(word)
      search_list(@@BLACK_PSOS,word)
    end

    #############################
    # 単語のホワイトリストに含まれていたらtrue
    #############################
    def white_word?(word)
      search_list(@@BLACK_WORDS,word)  
    end

    #############################
    # 単語のブラックリストに含まれていたらtrue
    #############################
    def black_word?(word)
      search_list(@@BLACK_WORDS,word)
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

