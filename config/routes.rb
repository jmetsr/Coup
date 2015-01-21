Rails.application.routes.draw do
  root to: 'static_pages#root'
  resources :users, defaults: {format: :json}
end
