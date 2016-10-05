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

set :puma_user, fetch(:user)
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix:///tmp/puma.socket"    #accept array for multi-bind
set :puma_default_control_app, "unix:///tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_path}/puma.rb"
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

# デプロイ前に実行する必要がある。
desc 'execute before deploy'
task :db_create do
  on roles(:db) do |host|
    execute "mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS データベース名;'"
  end
end

