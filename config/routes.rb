Rails.application.routes.draw do
  devise_for :users

  controller :dashboard do
    get :dashboard, action: 'show'
  end

  controller :tiny_urls do
    get '/s/:slug', action: :translate, as: :tiny_url_translate
  end

  resources :tiny_urls, only: [:new, :create]


  root to: 'tiny_urls#new'
end
