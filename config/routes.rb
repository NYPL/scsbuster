Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "refile", controller: 'items', action: 'refile'
  post "search_refile_errors", controller: 'items', action: 'search_refile_errors'
  get "transfer_metadata", controller: 'items', action: 'transfer_metadata'
  get "update_metadata", controller: 'items', action: 'update_metadata'
  get "authenticate", controller: 'oauth', action: 'authenticate'
  get "callback", controller: 'oauth', action: 'callback'
  get "log_out", controller: 'oauth', action: 'log_out'
  post "send_metadata", controller: 'items', action: 'send_metadata'
  post "send_transfer_metadata", controller: 'items', action: 'send_transfer_metadata'
  post "send_refile_request", controller: 'items', action: 'send_refile_request'
  get "error", controller: 'error', action: 'error'
  root controller: 'items', :action => 'update_metadata'
end
