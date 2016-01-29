class MatchRequest < ActiveRecord::Base
  belongs_to :user
  has_many :match_invites
  has_one :match

  validates :user_id, 
    numericality: {only_integer: true}
  validates :category, 
    inclusion: {within: ["singles", "doubles"]}
  validates :status,
    inclusion: {within: [nil, "failed", "accepted"]}
end