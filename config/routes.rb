Topclub::Application.routes.draw do

  delete '/sign_out' => 'users/omniauth_callbacks#destroy_user_session', as: 'quit'
  match '/enter_email(/:used_email)' => 'users/omniauth_callbacks#enter_email', as: 'enter_email'


  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root :to => 'explore#index'

  resources :explore

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
  end
  mount Ckeditor::Engine => "/ckeditor"
end
