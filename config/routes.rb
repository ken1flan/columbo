Rails.application.routes.draw do

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  root 'top#index'
  match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resource :user
  resource :reputation, only: [] do
    get 'pickup_tweets/:id/:up_down' => 'reputation#pickup_tweet'
  end

  resource :pickup_tweets_per_day, only: [:show]

  # admin
  namespace :admin do
    get '/' => 'top#index'
    resources :excluded_twitter_users
    resources :pickup_keywords
  end
  
  # for poor man's cron
  get 'cron/pickup_tweets' => 'cron#pickup_tweets'
  get 'cron/housekeep_tweets' => 'cron#housekeep_tweets'
  get 'cron/pickup_tweets_per_day' => 'cron#pickup_tweets_per_day'
  get 'cron/housekeep_pickup_tweets_per_day' => 'cron#housekeep_pickup_tweets_per_day'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
