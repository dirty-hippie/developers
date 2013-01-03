Topclub::Application.routes.draw do

  filter :locale

  post '/set_location/:location_slug' => 'places#set_location', as: 'set_location'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  delete '/sign_out' => 'users/omniauth_callbacks#destroy_user_session', as: 'quit'

  match '/enter_email(/:used_email)' => 'users/omniauth_callbacks#enter_email', as: 'enter_email'

  get '/confirm_account(/:token)' => 'users/omniauth_callbacks#confirm_account', as: 'confirm_account'

  post '/user_registration' => 'users/omniauth_callbacks#user_registration', as: 'user_registration'


  #refactor this


  resources :profile, module: :users do
    member do
      get :invite_friends
      get :self_reviews
      get :settings
      get :edit_settings
      put :update_settings
    end

    collection do
      post :send_email_invitation
    end
  end


  get '/new_reservation/:date,:place_id,:time,:amount_of_person' => 'reservations#new_reservation', as: 'new_reservation'

  get '/reservation_confirmed/:reservation_id' => 'reservations#reservation_confirmed', as: 'reservation_confirmed'

  post '/complete_reservation' => 'reservations#complete_reservation', as: 'complete_reservation'

  match 'autocomplete' => AutocompleteApp

  root :to => 'explore#index'

  resources :explore

  #resources :assets, :only => [:create, :destroy], :module => "admin" do
  #end

  resources :search do
    collection do
      get :get_more
      get :search
    end
  end

  resources :places do
    member do
      post :rate
      post :favorite
      post :planned
      post :visited
    end
  end

  resources :sandboxes do
    collection do
      get :search
      get :explorer
      get :search_map
      get :places
      get :stream
    end
  end

  namespace :admin do

    match 'main_image' => AdminMainImageApp
    match 'autocomplete' => AdminAutocompleteApp
    match 'place_feature' => PlaceFeatureApp

    get 'static_pages/:structure_id' => 'static_pages#show'

    root :to => "dashboards#index"

    resources :dashboards

    resources :categories do
      post :batch, :on => :collection
      post :rebuild, :on => :collection
    end


    resources :assets, :only => [:create, :destroy] do
      post :sort, :on => :collection
      get :description, :on => :collection
      post :update_description, :on => :collection
    end

    resources(:users) do
      post :batch, :on => :collection
      post :activate, :suspend, :on => :member
    end
    resources(:kitchens) do
      post :batch, :on => :collection
    end
    resources(:places) do
      post :batch, :on => :collection
    end
    resources(:group_features) do
      post :batch, :on => :collection
    end

    resources(:feature_items) do
      post :batch, :on => :collection
    end
    resources :locators do
      post :prepare, :reload, :cache_clear, :on => :collection
    end

    resources(:mark_types) do
      post :batch, :on => :collection
    end

    resources :cities do
      post :batch, :on => :collection
    end

  end
  mount Ckeditor::Engine => "/ckeditor"
end
