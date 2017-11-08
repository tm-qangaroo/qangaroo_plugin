require_dependency 'issues_controller'

module IssuesControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
    end
  end
end
