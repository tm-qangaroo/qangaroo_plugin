require_dependency 'project'

module Qangaroo
  module ProjectPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        has_many :qangaroo_issues
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  Project.send(:include, Qangaroo::ProjectPatch)
end
