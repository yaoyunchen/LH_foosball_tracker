class Request < ActiveRecord::Base
  belongs_to :user
  has_one :match

  validates :user_id, presence: true
  validates :recipient_id, presence: true
  validates :status, presence: true
end