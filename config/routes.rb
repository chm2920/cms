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
    
    get "topics/index"
    post "topics/index"
    get "topics/trashes"
    post "topics/trashes"
    get "topics/clear"
    delete "topics/del"
    post "topics/repost"
    resources :topics
    
    get "sea/rss"
    post "sea/rss"
    post "sea/import_rss"
    get "sea/auto"
    post "sea/auto"
    
    get "db/index"
    
    post "db/backup"
    post "db/restore"
    delete "db/destroy"
    
    get "db/sql"
    post "db/sql"
    
    get "db/tables"
    get "db/structure"
    post "db/export_sql"
      
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
  
  match "(:catalog_name)/(:catalog_name)/(:catalog_name)/:id" => "topics#show"
  match "(:catalog_name)/(:catalog_name)/:id" => "topics#show"
  match "(:catalog_name)/:id" => "topics#show"

  root :to => "start#index"
  
  match "*path" => "application#render_not_found"
  
end
