Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    
    resources :suppliers
    
    resources :purchase_orders do
      
      get :order, :on => :member
      get :receive, :on => :member
      
    end
    
    resources :purchase_order_lines do
      
      get :receive, :on => :member
      
    end
    
  end
end
