# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/qangaroo_plugin', to: 'services#index', as: :root
post '/create_api_key', to: 'services#create', as: :services
delete '/delete_api_key/:id', to: "services#destroy", as: :destroy_service
