Hypercouch::Application.routes.draw do

  # Feed Urls
  match '/feed' => 'posts#index', :as => :feed, defaults: { format: 'atom' }
  match '/atom/1' => redirect('/feed')

  # Sitemap
  match '/sitemap.xml' => 'posts#sitemap', defaults: {format: 'xml'}

  # Blitz.io auth
  get '/mu-bbae2a59-d0f182ac-6003de85-3cc7d260', :to => proc { |env| [200, {}, ["42"]] }

  # Sessions
  controller :sessions do
    get    'slogin'  => :new, :as => :login
    post   'slogin'  => :create, :as => :login
    get    'slogout' => :destroy, :as => :logout
    delete 'slogout' => :destroy, :as => :logout
  end

  # Backend Urls
  namespace :backend, :path => 'slogend' do
    resources :posts
    post '/idea/new' => 'dashboard#new_idea', :as => :new_idea

    root :to => 'dashboard#index'
  end

  get '/preview/:slug' => 'backend/posts#show', :as => :preview_post

  # The Hypercouch himself.
  controller :posts do
    get 'posts' => :index
    get '/archive' => :all, :as => :all_posts
    get ':slug' => :show, as: :post
  end

  root :to => 'posts#index'


end
