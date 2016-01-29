class Match < ActiveRecord::Base
  has_one :match_request
  has_many :match_results

  validates :match_request_id,
    numericality: {only_integer: true}

  validates :status,
    inclusion: {within: [nil, "cancelled", "over"]}

  after_create :create_match_results
 
  #Once the match is over, set the record status to over and update winners and losers.
  def match_over(winning_team)
    Match.find_by(id: self.id).update!(status: "over")
  
    update_results(winning_team)
  end

  #Updates participants based on if the game was cancelled.
  def match_cancelled
    Match.find_by(id: self.id).update!(status: "cancelled")
    begin
      players = MatchResult.where(match_id: self.id)
      MatchResult.transaction do
        players.each {|player| player.update!(result: 0)}
      end
    end 
  end

  #Updates participants based on the winning team.
  def update_results(winning_team)
    begin
      match = Match.find_by(id: self.id)
      if match.status == "over"
        winners = MatchResult.where(match_id: match.id, team: winning_team)
        losers = MatchResult.where(match_id: match.id).where.not(team: winning_team)
      
        MatchResult.transaction do
          winners.each {|winner| winner.update!(result: 1)}
          losers.each {|loser| loser.update!(result: -1)}
        end
      end
    rescue ActiveRecord::RecordInvalid
      self.status = "cancelled"
    end 
  end

  def last_ten_matches



  end

 private 
    #Once a match is created, link the User and Match tables through MatchResults.
    def create_match_results
      begin
        all_users = MatchInvite.where(match_request_id: match_request_id)

        results = []
        all_users.each do |user|
          results << MatchResult.new(
            match_id: self.id,
            user_id: user.user_id,
            team: user.team
          )
        end

        MatchResult.transaction do
          results.each {|participant| participant.save!}
        end
      rescue ActiveRecord::RecordInvalid
        self.status = "cancelled"
      end 
    end
end




