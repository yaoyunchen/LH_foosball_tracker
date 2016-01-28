class Match < ActiveRecord::Base
  has_many :users
  has_one :request

  validates :user1_id, presence: true
  validates :user2_id, presence: true
  validates :request_id, presence: true
end