Rails.application.routes.draw do
  get 'transactions/index'

  get 'transactions/show'

  get 'transactions/edit'

  get 'transactions/new'

  get 'transactions/update'

  get 'transactions/destroy'

  root to: 'pages#home'
end
