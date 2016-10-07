namespace :ikemen do
  desc "ikemenDBの初期セットアップを行う" 
  task :setup=> :environment do 
    #すべての設定を行う
  end

  desc "compareUserのリストのツイートを形態素解析し、名詞のみをcompareNounテーブルへ追加するタスク" 
  task :db_noun => :environment do 
    #compareUsersを読み込む -> compareNounテーブルの更新

  end

  desc "seedのtwitterIDリストを元に、CompareUsersテーブルへIDを追加する" 
  task :db_user => :environment do 
    #compareUsersテーブルをseedから更新

  end
end
