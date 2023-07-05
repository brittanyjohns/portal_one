Rails.application.routes.draw do
  resources :galleries do
    post "generate_image", on: :member
    post "generate_image_variation", on: :member
  end
  resources :templates
  devise_for :users
  get "home/index"
  resources :groups do
    resources :word_groups
  end
  resources :docs do
    post "mark_current", on: :member
    post "create_variation", on: :member
  end
  post "groups/:id/select_word/:word_id", to: "groups#select_word", as: :select_group_word
  post "groups/:id/select_words", to: "groups#select_words", as: :select_group_words

  resources :words do
    post "speak", on: :member
    post "generate_image", on: :member
    post "generate_image_variation", on: :member
  end
  resources :categories
  resources :posts
  resources :docs
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
