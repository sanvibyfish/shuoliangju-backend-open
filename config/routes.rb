Rails.application.routes.draw do
  resource :wechat, only: [:show, :create]
  resources :comments
  root to: 'home#index'
  mount ExceptionTrack::Engine => "/exception-track"

  devise_for :accounts, controllers: {
    sessions: 'accounts/sessions',
    registrations: 'accounts/registrations'
  }

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  resources :attachments
  resources :apps do
    resources :posts do
      member do
        post :excellent
        post :unexcellent
        post :top
        post :untop
        post :ban
        post :unban
      end
    end
    resources :reports do
      member do 
        post :ignore
        delete :destroy_post
        post :ban_post
        post :ban_user
        post :pass_post
      end
    end
    resources :sections
    resources :comments
    resources :articles do
      member do
        post :overdue
        post :published
      end
    end
    resources :users do
      member do
        post :set_admin
        post :unset_admin
        post :ban
        post :unban
      end
    end
  end

  

  namespace :admin do
    root :to => 'home#index'
    resources :accounts
  end

  namespace :api do
    namespace :v1 do
      resources :direct_uploads, only: [:create]
      resources :products
      resources :users do
        collection do
          get :info
        end
        member do
          get :like_posts
          get :posts
          get :star_posts
          post :follow
          post :unfollow
          get :followers
          get :following
          post :ban
          post :unban
          post :report
          post :add_white_list
        end
      end
      resources :apps do
        collection do
          get :app_config
        end
        member do
          get :members
          post :exit
          post :join  
          post :qrcode
        end
      end
      resources :articles do
        member do
          post :like
          post :unlike
        end
      end
      resources :posts do
        collection do
          get :discover
        end
        member do
          post :qrcode
          post :like
          post :unlike
          post :excellent
          post :unexcellent
          post :star
          post :unstar
          post :top
          post :untop
          post :ban
          post :unban
          post :report
        end
      end
      resources :comments do
        member do
          post :like
          post :unlike
        end
      end
      resources :attachments
      resources :sections
      resources :notifications do
        collection do
          get :likes
          get :comments
          get :unread_counts
          post :read
        end
      end
      resources :groups do
      end
      post '/auth/login', to: 'authentication#login'
      post '/auth/wechat_login', to: 'authentication#wechat_login'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
