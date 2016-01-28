class Match < ActiveRecord::Base
  has_many :users
  has_one :request

  validates :user1_id, 
    presence: true
  validates :user2_id, 
    presence: true
  validates :request_id, 
    presence: true

  validate :users_different

  private
    def users_different
      errors.add(:users1_id, "User 1 cannot be the same as User 2.") if :users1_id == :users2_id
    end
end