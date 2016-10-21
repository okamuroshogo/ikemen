class User < ApplicationRecord
  # create or updateされると呼ばれるcall back関数
  after_create :user_created
  after_update :user_cahnged

  ################################
  # twitter 認証のcallback がきた
  ################################
  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid = auth['uid']
      user.twitter_id = auth['info']['nickname']
    end
  end

  ################################
  # 偏差値を返す
  ################################
  def deviate
    calculate_deciation
  end

  #------------------------provate-------------------------
  private
    ###################################
    # userがcreateされた時
    ###################################
    def user_created
      # カウントを増やす
      update_cnt
    end

    ####################################
    # カラムの内容が更新された
    ####################################
    def user_cahnged
      return if self.changes['point'].nil? #カラムチェック
      # カウントは増やさずに偏差値を更新
      update_sum
    end

    ################################
    #　標準偏差を使わない偏差値
    ################################
    def calculate_deciation
      point = self.point
      sum = IkemenConfig.point_sum.value.to_f
      cnt = IkemenConfig.cnt.value.to_f
      ave = sum/cnt
      80 + (point + ave) / 2
    end

    ################################
    # userの数をincrementする
    ################################
    def update_cnt
      cnt = IkemenConfig.cnt
      @cnt = cnt.value.to_i + 1
      cnt.update(value: @cnt)
    end

    ################################
    # point合計をupdateする
    ################################
    def update_sum
      before =  self.point_was.nil? == true ? 0 : self.point_was
      sum = IkemenConfig.point_sum
      @sum = sum.value.to_i + self.point.to_i - before
      sum.update(value: @sum)
    end
end

