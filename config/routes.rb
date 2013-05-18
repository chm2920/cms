Cms::Application.routes.draw do 
  
  match "ajs/(:id).js" => "start#ajs"
  match "gb" => "start#gb"
  
  match "comments/(:id)" => "comments#create"
  
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
    post "sea/auto_result"
    
    get "db/index"
    
    post "db/backup"
    post "db/restore"
    delete "db/destroy"
    
    get "db/sql"
    post "db/sql"
    
    get "db/tables"
    get "db/structure"
    post "db/export_sql"
    
    get "sys/settings"
    post "sys/settings"
    
    get "sys/mark"
    post "sys/mark"
    
    get "sys/article_mix"
    post "sys/article_mix"
    
    get "sys/mails"
    post "sys/mails"
    
    post "ads/index"
    resources :ads
    
    post "friendlinks/batch_update"
    resources :friendlinks
    
    post "guestbooks/index"
    resources :guestbooks
    
    post "comments/index"
    resources :comments
      
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
  
  
  match "*news-:date-:id.html" => "topics#show"
  match ":root_catalog_cdir/:parent_catalog_cdir/:catalog_cdir" => "catalogs#show"
  match ":parent_catalog_cdir/:catalog_cdir" => "catalogs#list"
  match ":catalog_cdir" => "catalogs#list"

  root :to => "start#index"
  
  match "*path" => "application#render_not_found"
  
end
