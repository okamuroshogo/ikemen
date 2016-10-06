class TopController < BaseController
  require 'twitter'

  #index
  def index

  end

  #twitterの認証完了CallBack
  def callback
    auth = request.env['omniauth.auth']
    user = User.find_by_uid(auth['uid']) || User.create_with_omniauth(auth)
		getTimeLine
    session[:user_id] = user.id
    redirect_to root_path
  end

	#ログアウト処理
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private	
    # 自分のタイムラインを取得
    def getTimeLine
      Config::CLIENT.home_timeline.each do |tweet|
        puts tweet.full_text
      end
    end
end
