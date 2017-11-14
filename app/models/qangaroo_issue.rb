class QangarooIssue < ActiveRecord::Base
  belongs_to :issue
  belongs_to :project
  belongs_to :service
  validates :project_id, :issue_id, :qangaroo_project_id, :service_id, presence: true
end
