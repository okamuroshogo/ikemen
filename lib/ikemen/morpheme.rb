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
      result = []
      tweets.each do |tweet|
        full_text = url_replacement(tweet.full_text)
        Kuromoji.tokenize(full_text).each do |noun|
         noun.each do |pos|
            pos.split(",").each_with_index do |word,index|
              #単語は１文字だけの場合も排除
              #next if !search_list(@@WHITE_PSOS, word) || word.length < 2
              next if word_filter?(word)
              p noun[0]
              result << noun[0]
              break
            end
          end
        end
      end
      return result
    end

    #############################
    # 抽出する単語の条件を指定 true でスキップ
    #############################
    def word_filter?(word)
      #文字制限
      if word.length < 2
        return true
      end
      #ブラックリスト
      if black_pos?(word) || black_word?(word)
        return true
      end
      #ホワイトリスト
      if white_pos?(word) || white_word?(word)
        return false
      end
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

