require_dependency 'issue'

module Qangaroo
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        has_one :qangaroo_issue, dependent: :destroy
        alias_attribute :issueTypeId, :tracker_id
        alias_attribute :statusId, :status_id
        alias_attribute :priorityId, :priority_id
        alias_attribute :projectId, :project_id
        alias_attribute :summary, :subject
        alias_attribute :dueDate, :due_date
        after_update :update_qangaroo_issue

        def update_qangaroo_issue
          if self.qangaroo_issue.present?
            begin
              results = {self.qangaroo_issue.id => self.qangaroo_issue.issue}
              service = self.qangaroo_issue.qangaroo_service
              if service.active
                uri = URI.parse("http://#{service.namespace}/api/v1/redmine_services/update_issue")
                http = Net::HTTP.new(uri.host, uri.port)

                request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
                request.body = results.to_json
                request.add_field("X-Qangaroo-API-Key", service.api_key)
                
                res = http.request(request)
              end
            rescue
            end
          end
        end
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end

  ActionDispatch::Callbacks.to_prepare do
    Issue.send(:include, Qangaroo::IssuePatch)
  end
end
