class MatchParticipaction < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  validates :result
    inclusion: {within: [nil, -1, 0, 1]}
end