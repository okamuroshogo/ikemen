class ResultController < BaseController
  def loading
    #TODO 解析する
    point = Analyze::point_with_twitter_id(current_user.twitter_id)
    current_user.update(point: point)
    redirect_to action: 'result' , id: current_user.id
  end

  def result
    #TODO 結果を表示する
    @point = current_user.point
  end
end
