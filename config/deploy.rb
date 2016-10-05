# config valid only for current version of Capistrano
lock '3.6.1'
set :application, 'ikemen'
set :repo_url, 'https://github.com/okamuroshogo/ikemen.git'
set :branch, 'fix/cap-deploy' # デフォルトがmasterなのでこの場合書かなくてもいいです。
set :deploy_to, "/home/vagrant/"
set :scm, :git # capistrano3からgitオンリーになった気がするのでいらないかも?

set :format, :pretty
set :log_level, :debug # :info or :debug
set :keep_releases, 3 # 何世代前までリリースを残しておくか

set :rbenv_type, :user
set :rbenv_ruby, '2.2.4'
set :rbenv_path, '~/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value 

# デプロイ前に実行する必要がある。
desc 'execute before deploy'
task :db_create do
  on roles(:db) do |host|
    execute "mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS データベース名;'"
  end
end

