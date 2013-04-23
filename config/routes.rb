Cms::Application.routes.draw do
  
  match 'about/(:action)' => 'about#:action'
  
  match 'itemcats' => 'api#itemcats'
  match 'ct/(:id)' => 'api#ct'
  match 'i/(:id)' => 'api#i'
  
  match 'q' => 'api#q'
  match 'q/(:id)' => 'api#q'
  
  match 'phone' => 'start#phone'  
  
  match "admin" => "account#login"
  get "account/main"
  get "account/desktop"
  match "admin_login_rst" => "account#login_rst"
  match "admin_logout" => "account#logout"
  
  namespace :admin do  
    get "catalogs/batch_new"
    post "catalogs/batch_create"
    post "catalogs/batch_update"
    resources :catalogs do
      get :clear
    end
    
    resources :topics
      
    get "run_logs/index"
    post "run_logs/index"
    get "run_logs/clear"
    resources :run_logs
    
    resources :admins
  end
  
  namespace :kindeditor do
    post "/upload" => "assets#create"
    get  "/filemanager" => "assets#list"
  end

  root :to => "start#index"
  
  match "*path" => "application#render_not_found"
  
end
