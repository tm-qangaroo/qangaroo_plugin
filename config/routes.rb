# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/qangaroo_plugin', to: 'services#index', as: :root
post '/create_api_key', to: 'services#create', as: :services
delete '/delete_api_key/:id', to: "services#destroy", as: :destroy_service
get '/get_qangaroo_data/:id', to: 'services#get_qangaroo_data', as: :get_qangaroo_data
get '/show_qangaroo_data_path', to: "services#show_qangaroo_data", as: :show_qangaroo_data
post '/post_issue/:id', to: "services#register_issue", as: :register_issue
