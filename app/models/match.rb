class Match < ActiveRecord::Base
  has_one :match_request
  has_many :match_participactions

  validates :match_request_id,
    numericality: {only_integer: true}
  validates :status,
    inclusion: {within: [nil, "cancelled", "over"]}

  after_create :create_participactions
 


  def match_over(winning_team)
    Match.find_by(id: self.id).update!(status: "over")
  
    update_participactions(winning_team)
  end

  def match_cancelled
    Match.find_by(id: self.id).update!(status: "cancelled")
    begin
      players = MatchParticipaction.where(match_id: self.id)

      MatchParticipaction.transaction do
        players.each do |player|
          player.update!(result: 0)
        end
      end
    end 
  end

  def update_participactions(winning_team)
    begin
      match = Match.find_by(id: self.id)
      if match.status == "over"
        winners = MatchParticipaction.where(match_id: match.id, team: winning_team)
        losers = MatchParticipaction.where(match_id: match.id).where.not(team: winning_team)
        puts "some shit happened here."
        MatchParticipaction.transaction do
          winners.each do |winner|
            winner.update!(result: 1)
          end
          puts "updated winners."
          losers.each do |loser|
            loser.update!(result: -1)
          end
          puts "updated losers."
        end
      end
    rescue ActiveRecord::RecordInvalid
      #Change the match request to show that the invites failed.
      self.status = "cancelled"
    end 
  end

 private 


    def create_participactions
      begin
        all_users = MatchInvite.where(match_request_id: match_request_id)

        participactions = []
        all_users.each do |user|
          participactions << MatchParticipaction.new(
            match_id: self.id,
            user_id: user.user_id,
            team: user.team
          )
        end

        MatchParticipaction.transaction do
          participactions.each do |participant|
            participant.save!
          end
        end
      rescue ActiveRecord::RecordInvalid
        #Change the match request to show that the invites failed.
        self.status = "cancelled"
      end 
    end
end




