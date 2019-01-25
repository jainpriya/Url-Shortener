Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  get 'users/new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources:urls
  root 'welcome#index'
  post 'url_shorteners' => 'urls#create'
  get 'long_url' => 'urls#get_long_url'
  get 'go_to' => 'urls#go_to'

  get 'retrieve_url'=>'search#retrieve_url'

  get 'counter/report'
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web, :at => '/sidekiq'
  get '/search' => 'search#search'
end
