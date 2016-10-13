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
  get '/share'                            => 'result#share'
  get '/share_complete'                   => 'result#share_complete'

end
