# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

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
