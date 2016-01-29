class MatchParticipaction < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  validates :match_id,
    numericality: {only_integer: true}
  validates :user_id,
    numericality: {only_integer: true}
  validates :result,
    inclusion: {within: [nil, -1, 0, 1]}
end