class MatchRequest < ActiveRecord::Base
  belongs_to :user
  has_many :match_invites
  has_one :match

  # validates :user_id, presence: true
  # validates :recipient_id, presence: true
  # validates :status, presence: true
end