require 'complex'
namespace :ikemen do
  desc "ikemenDBの初期セットアップを行う" 
  task setup: :environment do 
  #すべての設定を行う
    #compareユーザーの追加
    Rake::Task["ikemen:db_user"].execute
    #単語リストの全削除
    CompareNoun.delete_all
    #単語の追加
    Rake::Task["ikemen:db_noun"].execute
  end

  desc "compareUserのTweetをcompareNounテーブルへ追加" 
  task db_noun: :environment do 
    #compareUsersを読み込む -> compareNounテーブルの更新
    CompareUser.all.each do |compare_user|
      Analyze::glow_compare_nouns(compare_user)
    end
  end

  desc "seedのtwitterIDリストを元に、CompareUsersテーブルへIDを追加" 
  task db_user: :environment do 
    #compareUsersテーブルをseedから更新
    #CompareUserを全削除
    CompareUser.delete_all
    #入れ直す
    Rake::Task["db:seed"].execute
  end

  desc "twitter_idを指定して、イケメン度を算出 [ rails ikemen:point TWITTER_ID='xxxxxxxxxxx' IS_MALE=0 or 1]"
  task point: :environment do
    twitter_id = ENV['TWITTER_ID'].to_s
    #TODO true false 変換メソッドを定義
    is_male = ENV['IS_MALE'].to_i == 1 ? true : false
    p Analyze::point_with_twitter_id(twitter_id, is_male)

  end

  desc "厳密に偏差値を計算する  [ rails ikemen:deviate TWITTER_ID='xxxxxxxxxxx' IS_MALE=0 or 1]"
  task deviate: :environment do
    twitter_id = ENV['TWITTER_ID'].to_s
    is_male = ENV['IS_MALE'].to_i == 1 ? true : false
    point = Analyze::point_with_twitter_id(twitter_id, is_male).to_f
    ave = User.average(:point).to_f
    sub_sum = 0
    User.all.each do |user|
      sub_sum += (user.point - ave) ** 2
    end
    p (point - ave) * 10 / Math.sqrt(sub_sum / User.count) + 50
  end
end

