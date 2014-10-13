Rails.application.routes.draw do

  get 'common/hot'
  get 'hot'=>'common#hot'
  get 'common/featured'
  get 'featured'=>'common#featured'
  get 'common/sponsored'
  get 'sponsored'=>'common#sponsored'
  get 'common/donate'
  get 'donate'=>'common#donate'

  resources :comments

  root 'static_pages#root'

  get 'toc'=>'static_pages#toc'
  get 'about'=>'static_pages#about'
  get 'admin'=>'static_pages#admin'

  namespace :admin do
    resources :users
    resources :transfers
  end

  resources :users do
    member do
      get 'dashboard'
      post 'dashboard'
      post 'dashboard_transfer_list'
      get 'pending_validation'
      get 'resend_validation'
      get 'new_validation'
      patch 'update_password'
      get 'change_password'
      get 'friends'
    end
    collection do
      get 'validate'
      get 'forgot_password'
      post 'temp_password'
    end
  end

  resources :transfers do
    member do
      post 'accept'
      post 'cancel'
      post 'complete'
      post 'fail'
      post 'off_dashboard'
    end
    collection do
      get 'recent'
    end
  end

  get 'sessions/new'
  post 'sessions/create'
  delete 'sessions/destroy'
  post 'sessions/impersonate'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
