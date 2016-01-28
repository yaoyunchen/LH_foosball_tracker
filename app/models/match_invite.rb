class MatchInvite < ActiveRecord::Base
  belongs_to :match_request
  belongs_to :user
end