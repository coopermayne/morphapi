Rails.application.routes.draw do

  get 'search' =>  'search_results#index'

  #no sign up
  devise_for :users, path_prefix: 'd',  controllers: { registrations: "registrations"}

  #admin routes
  namespace :admin do
    get 'press_list' => 'press#index'
    get 'clear_press_list' => 'press#clear'

		resources :uploads
    resources :slides do
      collection do
        put :rank
      end
    end
		resources :people
		resources :positions
		resources :news_items
		resources :projects

    resources :project_types do
      collection do
        put :rank
      end
    end

    #minor
    resources :news_types
    resources :file_types
    resources :credits

    resources :users
    resources :awards
    resources :bibliography_items
  end


  get 'menu' => 'menu#index'
  get 'video_slides' => 'menu#videos'
  root to: redirect('admin/projects')

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  resources :projects, only: [:index, :show]
  resources :awards, only: [:index, :show]
  resources :bibliography_items, only: [:index, :show]
  resources :news_items, path: "news", only: [:index, :show]
  resources :people, only: [:index, :show]
  resources :media, only: [:index, :show]

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
