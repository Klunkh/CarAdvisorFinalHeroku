
 Rails.application.routes.draw do
  

  get '/operazionis/index' => redirect('/')
	

  post 'users/new' => 'users#new'
  
  get 'conversaziones/new'
  patch '/conversaziones' => 'conversaziones#cancella_notifica_messaggi'
  post '/conversazione' => 'conversaziones#index'
  post '/conversaziones' => 'conversaziones#create'
  get 'conversaziones/index' => 'conversaziones#index'
  post '/conversaziones/index' => 'conversaziones#load_conversazione'
  patch '/conversaziones/index' => 'conversaziones#reload'
  post '/ratings' => 'ratings#create'
  post '/ratings/:id' => 'ratings#update'
  get 'preferitis/:id' => 'preferitis#destroy'
  patch '/notificas' => 'notificas#test'
  post '/preferitis' => 'preferitis#create'
  get 'operazionis/new'
  post '/operazionis' => 'operazionis#create'
  get 'operazionis/:id/edit' => 'operazionis#edit'
  patch 'operazionis/:id' => 'operazionis#update'
  delete 'operazionis/:id' => 'operazionis#destroy'
  
  get 'operazionis/:id' => 'operazionis#show'
  
  get 'scadenzes/index' =>redirect('/')
  get 'scadenzes/:id/edit' =>redirect('/')
  get 'scadenzes/edit' =>redirect('/')
  
  get 'officinas/new'
  get 'officinas/show'
  get 'officinas/edit'
  get 'officinas/index' =>'officinas#index'
  post '/officinas' => 'officinas#create'
  post '/officinas/:id' => 'officinas#setta_cortesia'
  delete 'officinas/:id' => 'officinas#destroy'
  patch 'officinas/:id' => 'officinas#update'
  get 'officinas/:id' => 'officinas#show'
  get 'officinas/:id/edit' => 'officinas#edit'

  get 'autoveicolos/edit'
  delete 'autoveicolos/:id' => 'autoveicolos#destroy'
  get 'autoveicolos/' => 'autoveicolos#index'
  get 'autoveicolos/show'
  get 'autoveicolo/show'
  get 'password_resets/new'
  get 'password_resets/edit'
 
  get 'contattaci' => 'pagina_statica#contattaci'
  get 'faq' => 'pagina_statica#faq'
  
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  


  resources :users, shallow: true
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :autoveicolos,   only: [:new, :create, :edit, :update, :show]
  resources :officinas, only: [:new]
  resources :scadenzes
  root                'pagina_statica#home'
  get '*missing' => redirect('/')
end
