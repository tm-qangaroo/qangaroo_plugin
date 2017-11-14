class Service < ActiveRecord::Base
  validates :api_key, presence: true
  validates :namespace, presence: true
  belongs_to :user
  has_many :qangaroo_issues, dependent: :destroy

  def self.get_tracker(param)
    if param == "タスク" || nil
      return 1
    elsif param == "バグ"
      return 2
    else
      return 3
    end
  end

  def self.get_priority(param)
    return nil if !param
    if param == "trivial"
      return 1
    elsif param == "minor"
      return 2
    elsif param == "major"
      return 3
    elsif param == "critical"
      return 4
    elsif param == "blocker"
      return 5
    end
  end

end
