class Service < ActiveRecord::Base
  validates :api_key, presence: true
  validates :namespace, presence: true
  belongs_to :user
  
end
