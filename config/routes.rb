Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    
    resources :suppliers
    
    resources :purchase_orders
    
    delete '/purchase_order_lines/:id', :to => "purchase_order_lines#destroy", :as => :purchase_order_line
    
  end
end
