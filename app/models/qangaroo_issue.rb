class QangarooIssue < ActiveRecord::Base
  belongs_to :issue
  belongs_to :project
  validates :project_id, :issue_id, :qangaroo_project_id, presence: true
end
