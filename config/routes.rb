Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/random', to: 'search#show'
        get '/find',   to: 'search#show'
      end

      namespace :customers do
        get '/find_all', to: 'search#index'
        get '/random', to: 'search#show'
        get '/find',   to: 'search#show'
      end

      namespace :items do
        get '/find_all', to: 'search#index'
        get '/random', to: 'search#show'
        get '/find',   to: 'search#show'
      end

      namespace :invoices do
        get '/find_all', to: 'search#index'
        get '/random', to: 'search#show'
        get '/find',   to: 'search#show'
      end

      namespace :transactions do
        get '/find_all', to: 'search#index'
        get '/random', to: 'search#show'
        get '/find',   to: 'search#show'
      end

      namespace :invoice_items do
        get '/find_all', to: 'search#index'
        get '/random', to: 'search#show'
        get '/find',   to: 'search#show'
      end

      resources :merchants, only: [:index, :show] do
        # resources :items, only: [:index]
        get '/items', to: 'merchants/items#index'
        get '/invoices', to: 'merchants/invoices#index'
        get 'most_revenue', to: 'merchants/mostrevenue#index'
        get 'most_items', to: 'merchants/mostitems#index'
        get 'revenue', to: 'merchants/revenue#show'
        get 'favorite_customer', to: 'merchants/bestcustomer#show'

      end

      resources :invoices, only: [:index, :show] do
        get 'transactions', to: 'invoices/transactions#index'
        get 'invoice_items', to: 'invoices/invoice_items#index'
        get 'items', to: 'invoices/items#index'
        get 'customer', to: 'invoices/customer#show'
        get 'merchant', to: 'invoices/merchant#show'
      end

      resources :invoice_items, only: [:index, :show] do
        get 'invoice', to: 'invoice_items/invoice#show'
        get 'item', to: 'invoice_items/item#show'
      end

      resources :items, only: [:index, :show] do
        get 'invoice_items', to: 'items/invoice_items#index'
        get 'merchant', to: 'items/merchant#show'
        get 'most_revenue', to: 'items/mostrevenue#index'
        get 'most_items', to: 'items/mostitems#index'
        get 'best_day', to: 'items/bestday#index'

      end

      resources :transactions, only: [:index, :show] do
        get 'invoice', to: 'transactions/invoice#show'
      end

      resources :customers, only: [:index, :show] do
        get 'invoices', to: 'customers/invoices#index'
        get 'transactions', to: 'customers/transactions#index'
        get 'favorite_merchant', to: 'customers/bestmerchant#index'
      end

    end
  end

end

Customers
GET /api/v1/customers/:id/favorite_merchant
