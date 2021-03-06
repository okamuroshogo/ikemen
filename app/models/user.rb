class User < ApplicationRecord
  # create or updateされると呼ばれるcall back関数
  after_create :user_created
  after_update :user_changed

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
    def user_changed
      return if self.changes['point'].nil? #カラムチェック
      # カウントは増やさずに偏差値を更新
      update_sum
    end

    ################################
    #　標準偏差を使わない偏差値
    ################################
    def calculate_deciation
      point = self.point
      ikemen_info = info_hash(IkemenConfig.deciation_info)
      sum = ikemen_info['sum'].to_f
      cnt = ikemen_info['cnt'].to_f
      ave = sum/cnt
      30 + (point - ave) / 2    
    end

    ################################
    # 偏差値算出に必要な値をhashで返す
    ################################
    def info_hash(info_array)
      result = {}
      info_array.each do | info |
        case info.key
        when IkemenConfig::KEY_POINT_SUM
          result['sum'] = info.value
        when IkemenConfig::KEY_USER_COUNT
          result['cnt'] = info.value
        end
      end
      result
    end

    ################################
    # userの数をincrementする
    ################################
    def update_cnt
      cnt = IkemenConfig.cnt
      cnt.with_lock do
        @cnt = cnt.value.to_i + 1
        cnt.update(value: @cnt)
      end
    end

    ################################
    # point合計をupdateする
    ################################
    def update_sum
      before =  self.point_was.nil? == true ? 0 : self.point_was
      sum = IkemenConfig.point_sum
      sum.with_lock do
        @sum = sum.value.to_i + self.point.to_i - before
        sum.update(value: @sum)
      end
    end
end

