class QangarooIssue < ActiveRecord::Base
  unloadable
  belongs_to :issue
  belongs_to :project
end
