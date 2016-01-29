class MatchInvite < ActiveRecord::Base
  belongs_to :match_request
  belongs_to :user

  validates :user_id,
    numericality: {only_integer: true}

  validates :match_request_id,
    numericality: {only_integer: true}

  validates :team,
    presence: true

  after_update :create_match

  private

    def create_match
      all_invites = MatchInvite.where(match_request_id: self.match_request_id)

      if all_users_ready?(all_invites)
        #Once all users are ready, create the match.
        Match.create!(
          match_request_id: self.match_request_id
        )
        #Change status of request to accepted.
        MatchRequest.find_by(id: self.match_request_id).update!(status: "accepted")
      end
    end

    #Checks if all users have accepted.
    def all_users_ready?(all_invites)
      ready = true
      all_invites.each do |invite|
        ready = false unless invite.accept
      end
      ready
    end
end