# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'ikemen'
set :repo_url, 'https://github.com/okamuroshogo/ikemen.git'
set :branch, 'statging/deployment' # デフォルトがmasterなのでこの場合書かなくてもいいです。
set :deploy_to, "/home/ec2-user/"
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

set :puma_user, fetch(:user)
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "/tmp/pids/puma.state"
set :puma_pid, "/tmp/pids/puma.pid"
set :puma_bind, "unix:///tmp/sockets/puma.socket"    #accept array for multi-bind
#set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind

set :puma_default_control_app, "unix:///tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'development'))
set :puma_threads, [0, 16]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_preload_app, false
set :puma_plugins, []  #accept array of plugins
set :nginx_use_ssl, false

set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }


# デプロイ前に実行する必要がある。
desc 'execute before deploy'
task :db_create do
  on roles(:db) do |host|
    execute "mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS データベース名;'"
  end
end

namespace :deploy do
  namespace :upload do
    desc 'Upload .env'
    before :"puma:check", :puma_conf do
      on roles(:app) do |host|
        upload! "config/puma.rb", "#{shared_path}/config/puma.rb"
      end
    end
  end
end

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir /tmp/sockets -p"
      execute "mkdir /tmp/pids -p"
    end
  end

  before :start, :make_dirs
end
