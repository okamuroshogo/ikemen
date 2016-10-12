class SessionController < ApplicationController
  
  #twitterの認証完了CallBack
  def callback
    auth = request.env['omniauth.auth']
    user = User.find_by(uid: auth['uid']) || User.create_with_omniauth(auth)
    Analyze::getTweet(user.uid.to_i)
    session[:user_id] = user.id
    redirect_to root_path
  end

  #ログアウト処理
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end
