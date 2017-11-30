class QangarooService < ActiveRecord::Base
  validates :api_key, presence: true
  validates :namespace, presence: true
  belongs_to :user
  has_many :qangaroo_issues, dependent: :destroy

  def verify_and_update(qangaroo_fields)
    self.update(name: qangaroo_fields["name"]) if self.name != qangaroo_fields["name"]
    self.update(api_key: qangaroo_fields["api_key"]) if self.api_key != qangaroo_fields["api_key"]
    self.update(active: true) unless self.active
  end
end
