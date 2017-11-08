require_dependency 'project'

module ProjectPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      has_many :qangaroo_issues
    end
  end

  module ClassMethods
  end

  module InstanceMethods
  end
end

ActionDispatch::Callbacks.to_prepare do
  Project.send(:include, ProjectPatch)
end
