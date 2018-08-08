Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "refile", controller: 'items', action: 'refile'
  get "transfer_metadata", controller: 'items', action: 'transfer_metadata'
  get "update_metadata", controller: 'items', action: 'update_metadata'
  post "send_metadata", controller: 'items', action: 'send_metadata'
  post "send_transfer_metadata", controller: 'items', action: 'send_transfer_metadata'
  root controller: 'items', :action => 'update_metadata'
end

