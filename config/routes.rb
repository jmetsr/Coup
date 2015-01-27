Rails.application.routes.draw do
  
  root to: 'static_pages#root'
  resources :users, defaults: {format: :json}
  post 'games/propose', :to => 'games#propose'
end
