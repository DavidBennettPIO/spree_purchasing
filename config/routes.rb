Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :suppliers
    resources :purchase_orders
  end
end
