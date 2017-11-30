# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

namespace :api do
  namespace :v1 do
    get '/qangaroo_services/verify_qangaroo_plugin', to: 'qangaroo_services#verify_qangaroo_plugin', as: :api_verify_qangaroo_plugin
    get '/qangaroo_services/create_service', to: 'qangaroo_services#create_service'
    get '/qangaroo_services/delete_service', to: 'qangaroo_services#delete_service'
    get '/qangaroo_services/provide_projects', to: 'qangaroo_services#provide_projects'
    get '/qangaroo_services/get_redmine_fields/:id', to: 'qangaroo_services#get_redmine_fields'
    post '/qangaroo_services/register_issue', to: 'qangaroo_services#register_issue'
    post '/qangaroo_services/get_updated_issues', to: 'qangaroo_services#get_updated_issues'
    put '/qangaroo_services/update_issue', to: 'qangaroo_services#update_issue'
  end
end
