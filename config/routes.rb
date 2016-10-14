Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # root
root :to => 'top#index'

  # session
  get '/auth/:provider/callback', :to     => 'session#callback'
  post '/auth/:provider/callback', :to    => 'session#callback'
  get '/logout'                           => 'session#destroy', :as => :logout

  #anlyze/result
  get '/analyze'                          => 'result#loading'
  get '/result/:id'                       => 'result#result'
  get '/result/view/:id'                  => 'result#view'
  get '/share'                            => 'result#share'
  get '/share_complete'                   => 'result#share_complete'

  #404 error
  get '*path', controller: 'application', action: 'render_404'

end
