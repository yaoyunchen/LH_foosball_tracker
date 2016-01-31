class MatchInvite < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  validates :user_id,
    numericality: {only_integer: true}

  validates :match_id,
    numericality: {only_integer: true}

  validates :side,
    presence: true

   after_update :check_if_ready

  private

    def check_if_ready
      all_invites = MatchInvite.where(match_id: self.match_id)

      if all_users_ready?(all_invites)
        #Once all users are ready, create the match.
        Match.find_by(id: self.match_id).update!(
          status: "set"
        )
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