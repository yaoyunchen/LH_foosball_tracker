class Match < ActiveRecord::Base
  has_one :match_request
  has_many :match_participactions

  validates :match_request_id,
    numeralicality: {only_integer: true}
  validates :status,
    inclusion: {within: ["set", "cancelled", "finished"]}

  after_update :update_participants

  private 

    #Once the match is finished, update the MatchParticipaction table with wins/losses.  If the game is dropped, update it with cancelled.
    def update_participants
      if self.status == "finished"
        
      end
      if self.status == "cancelled"

      end
    end
end