Rails.application.routes.draw do
  
  root to: 'static_pages#root'
  resources :users, defaults: {format: :json}
  post 'games/propose', :to => 'games#propose'
  get 'games/accept' => 'games#accept', :as => 'accept'
  get 'games/reject' => 'games#reject', :as => 'reject'
  resources :games, defaults: {format: :json}
end
