# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/qangaroo_plugin', to: 'services#index', as: :root
post '/create_api_key', to: 'services#create', as: :services
delete '/delete_api_key/:id', to: "services#destroy", as: :destroy_service
get '/get_qangaroo_data/:id', to: 'services#get_qangaroo_data', as: :get_qangaroo_data
get '/show_qangaroo_data_path', to: "services#show_qangaroo_data", as: :show_qangaroo_data
post '/post_issue/:id', to: "services#register_issue", as: :register_issue

namespace :api do
  namespace :v1 do
    get '/services/verify_qangaroo_plugin', to: 'services#verify_qangaroo_plugin', as: :api_verify_qangaroo_plugin
    get '/services/create_service', to: 'services#create_service'
    get '/services/delete_service', to: 'services#delete_service'
    get '/services/provide_projects', to: 'services#provide_projects'
    get '/services/get_redmine_fields/:id', to: 'services#get_redmine_fields'
    post '/services/register_issue', to: 'services#register_issue'
    put '/services/update_issue', to: 'services#update_issue'
    get '/services/get_updated_issues', to: 'services#get_updated_issues'
  end
end
