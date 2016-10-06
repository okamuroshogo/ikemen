Rails.application.routes.draw do
	root :to => 'top#index'
	get '/auth/:provider/callback', :to => 'session#callback'
	post '/auth/:provider/callback', :to => 'session#callback'
	get '/logout' => 'session#destroy', :as => :logout
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
