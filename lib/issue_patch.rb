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
