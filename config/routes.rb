Rails.application.routes.draw do
  root to: 'pages#home'
  post '/', to: 'pages#home', as: 'home'
end
