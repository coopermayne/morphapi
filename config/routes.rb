Rails.application.routes.draw do

  get 'search' =>  'search_results#index'

  #no sign up
  devise_for :users, path_prefix: 'd',  controllers: { registrations: "registrations"}

  get 'press_list' => 'press#create'

  # admin routes
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

  resources :projects, only: [:index, :show]
  resources :awards, only: [:index, :show]
  resources :bibliography_items, only: [:index, :show]
  resources :news_items, path: "news", only: [:index, :show]
  resources :people, only: [:index, :show]
  resources :media, only: [:index, :show]

end
