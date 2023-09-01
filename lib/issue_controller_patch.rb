require_dependency 'issues_controller'

module IssueControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
    end
  end
end
