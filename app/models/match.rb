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
      #winning side is integer, player side was string
      if player.side.to_i == winning_side.to_i
        win = 1
      else
        loss = 1
      end
      puts win
      puts loss
      SinglesResult.create(
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
      team == winning_side ? win = 1 : loss = 1

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

  def relative_time
    a = (Time.now - self.created_at).to_i

    case a
      when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then a.to_s+' seconds ago' 
      when 60..119 then 'a minute ago' #120 = 2 minutes
      when 120..3540 then (a/60).to_i.to_s+' minutes ago'
      when 3541..7100 then 'an hour ago' # 3600 = 1 hour
      when 7101..82800 then ((a+99)/3600).to_i.to_s+' hours ago' 
      when 82801..172000 then 'a day ago' # 86400 = 1 day
      when 172001..518400 then ((a+800)/(60*60*24)).to_i.to_s+' days ago'
      when 518400..1036800 then 'a week ago'
      else ((a+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
    end
  end 
    
end




