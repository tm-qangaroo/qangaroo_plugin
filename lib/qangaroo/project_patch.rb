require_dependency 'project'

module Qangaroo
  module ProjectPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        has_many :qangaroo_issues, dependent: :destroy
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end

ActiveSupport::Reloader.to_prepare do
  Project.send(:include, Qangaroo::ProjectPatch)
end
