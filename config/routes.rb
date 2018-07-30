Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "refile", controller: 'items', action: 'refile'
  get "transfer_metadata", controller: 'items', action: 'transfer_metadata'
  get "update_metadata", controller: 'items', action: 'update_metadata'
  get "login", controller: 'oauth', action: 'login'
  root controller: 'items', :action => 'update_metadata'
end

