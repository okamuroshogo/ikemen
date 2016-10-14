class ResultController < BaseController

  ###############################
  # 解析する
  ###############################
  def loading
    point = Analyze::point_with_twitter_id(current_user.twitter_id)
    current_user.update(point: point)
    redirect_to action: 'result' , id: current_user.id
  end

  ##############################
  # 結果を表示する
  ##############################
  def result
    @user = current_user
    @text = tweet_text
    current_user.update(detail: @text)
  end

  ##############################
  # 他人のページを参照する時
  ##############################
  def view
    @user = User.find_by(id: params[:id])
    if @user.is_hidden
      # アクセスが許可されていないので404 ページへ飛ばす
      redirect_to action: 'render_404'
    else
      @text = @user.detail
    end
  end

  ##############################
  # シェアする
  ##############################
  def share
    @text = tweet_text
    Config::CLIENT.update(@text)
    flash[:notice] = "tweet: #{@text}"
    redirect_to action: 'share_complete'
  end

  #############################
  #シェア完了
  #############################
  def share_complete
  end

  private 

    #############################
    # シェアする文字を作成
    #############################
    def tweet_text
      url = bitly_shorten(ENV['RESULT_URL'].to_s + current_user.id.to_s)
      ENV['TWITTER_SHARE_TEXT1'].to_s + current_user.point.to_s + ENV['TWITTER_SHARE_TEXT2'].to_s + url.to_s + "\n"
    end

    ###########################
    #　投稿するURLを短縮
    ###########################
    def bitly_shorten(url)
      Bitly.use_api_version_3
      Bitly.configure do |config|
        config.api_version = 3
        config.access_token = ENV['BITLY_TOKEN']
      end
      Bitly.client.shorten(url).short_url
    end
end


