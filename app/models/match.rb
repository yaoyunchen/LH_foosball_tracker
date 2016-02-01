class Match < ActiveRecord::Base
  belongs_to :user
  has_many :match_invites
  has_many :singles_results
  has_many :doubles_results

  validates :status,
    inclusion: {within: [nil, "set","cancelled", "over"]}

  #Once the match is over, set the record status to over and update winners and losers.
  def match_over(winning_side)
    self.update!(status: "over")
  
    create_results(winning_side)
  end

  #Updates participants based on if the game was cancelled.
  def match_cancelled
    Match.find_by(id: self.id).update!(status: "cancelled")
  end

  #Create results after match is over.
  def create_results(winning_side)
    self.category == "singles" ? create_singles_results(winning_side) : create_doubles_results(winning_side)
  end

  def create_singles_results(winning_side)
    players = MatchInvite.where(match_id: self.id)
    players.each do |player|
      win = 0
      loss = 0
      player.side == winning_side ? win += 1 : loss += 1
      puts win
      puts loss
      SinglesResult.create!(
        match_id: self.id,
        user_id: player.user_id,
        side: player.side,
        win: win,
        loss: loss
      )
    end
  end

  def create_doubles_results(winning_side)
    teams = update_teams

    teams.each do |team|
      members = Team.find_by(members: team)
      win = 0
      loss = 0
      team == winning_side ? win += 1 : loss += 1

      members.doubles_results.create!(
        match_id: self.id,
        team_id: members.id,
        win: win,
        loss: loss
      )
    end

  end

  def create_team(members)
    Team.create!(
      members: members
    )
  end

  def update_teams
    players = MatchInvite.where(match_id: self.id)

    left = players.where(side: players[0].side).order(:user_id)
    right = players.where.not(side: players[0].side).order(:user_id)

    left_team = "#{left[0].user_id},#{left[1].user_id}"
    right_team = "#{right[0].user_id},#{right[1].user_id}"

    create_team(left_team) unless Team.find_by(members: left_team)

    create_team(right_team) unless Team.find_by(members: right_team)
    
    result = [left_team, right_team]
  end

  def pretty_time
    time = updated_at.localtime.strftime("%I:%M %p").downcase
    time.slice!(0) if time.starts_with?('0')
    time
  end
    
end




