Rails.application.routes.draw do

  #mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :messages
  resources :attendances

  root 'users#index'
  #root 'welcome#index'

  # Pages
  get 'discover' => 'pages#discover', :as => 'discover'
  get 'welcome' => 'pages#welcome', :as => 'welcome'
  get 'upcoming' => 'pages#upcoming', :as => 'upcoming'
  get 'past' => 'pages#past', :as => 'past'

  # Users
  devise_for :users, :controllers => { sessions: 'sessions', registrations: 'registrations', omniauth_callbacks: "omniauth_callbacks", confirmations: "confirmations" }
  as :user do
    get 'login' => 'sessions#new', :as => "login"
    get 'signup' => 'registrations#new', :as => "signup"
  	get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users do
    get 'edit/overview' => 'users#edit_overview'
    get 'edit/photo' => 'users#edit_photo'
    get 'edit/account' => 'users#edit_account'
    get 'attending' => 'users#attending'
    get 'attended' => 'users#attended'

	  resources :events do
      get 'edit/overview' => 'events#overview'
      get 'index/schedules' => 'events#index_schedules'
      get 'edit/schedules' => 'events#edit_schedules'
      get 'edit/speakers' => 'events#speakers'
      get 'speakers/index' => 'events#index_speakers'
      get 'about' => 'events#about'
      get 'attendees' => 'events#attendees'
    end
  end

  # Event Dates
  post 'event_dates/ajax_event_session' => 'event_dates#ajax_event_session'
  resources :event_dates do
    resources :event_sessions
  end

  # Event Sessions
  resources :event_sessions do
    collection { post :sort }
  end

  # Speakers
  resources :speakers


  # Messages
  get "chat", to: "messages#index", as: "chat"
  post 'pusher/auth' => 'pusher#auth'
  post 'messages/display_messages' => 'messages#display_messages'
  post 'messages/append_message' => 'messages#append_message'



end
