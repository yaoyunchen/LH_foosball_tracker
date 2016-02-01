LIMIT = 10

get '/leaderboard' do

  singles_array = build_singles_array
  singles_array = singles_array.sort_by {|k| k[:ratio] * k[:plays]}.reverse
  @singles = []
  count = 0
  singles_array.each do |ele|
    if count <= LIMIT
      count += 1
      @singles << ele
    end
  end
  @singles


  doubles_array = build_doubles_array
  doubles_array = doubles_array.sort_by {|k| k[:ratio] * k[:plays]}
  @doubles = []
  count = 0
  doubles_array.each do |ele|
    if count <= LIMIT
      count += 1
      @doubles << ele
    end
  end
  @doubles


  latest_array = build_latest_array
  @latest = []
  count = 0
  latest_array.each do |ele|
    if count <= LIMIT
      count +=1
      @latest << ele
    end
  end
  @latest 


  most_active_array = build_most_active_array
  @actives = most_active_array.sort_by {|k| [:total]}
  @doubles = []

  erb :'leaderboard/index'
end


def build_singles_array
  # Get all the users who played singles games.
  singles_players = SinglesResult.select(:user_id).distinct
  players_info_array = []
  singles_players.each do |player|
    # Get specific information about the player.
    user = User.find_by(id: player.user_id)
    user_info = {
      username: user.username,
      img_path: user.img_path,
      wins: user.singles_wins,
      losses: user.singles_losses,
      ratio: user.singles_ratio,
      plays: user.singles_total_plays
    }
    players_info_array << user_info
  end
  players_info_array
end

def build_doubles_array

  # Get all the teams in doubles games.
  teams = DoublesResult.select(:team_id).distinct
  team_info_array = []
  
  teams.each do |members|
    team = Team.find_by(id: members.team_id)

    #Get specific information about each team member.  
    members = team.members.split(',')
    users = []

    members.each do |member|
      user = User.find_by(id: member.to_i)
      users << {username: user.username, img_path: user.img_path}
    end

    team_info = {
      team: users,
      wins: team.team_wins,
      losses: team.team_losses,
      ratio: team.team_ratio,
      plays: team.team_total_plays
    }
    team_info_array << team_info
  end

  team_info_array
end


def build_latest_array

  latest_matches = Match.where(status: "over").order(updated_at: :desc)

  matches_array = []
  latest_matches.each do |match|
    time = match.pretty_time
    type = match.category
    winner = ""
    teams = []
    if type == "singles"
      results = SinglesResult.where(match_id: match.id)
      
      results.each do |result|
        player = User.find_by(id: result.user_id)
        teams << {username: player.username, img_path: player.img_path}
        winner = {username: player.username, img_path: player.img_path} if result.win == 1
      end
    else
      results = DoublesResult.where(match_id: match.id)

      results.each do |result|
        team = Team.find_by(id: result.team_id)

        #Get specific information about each team member.  
        members = team.members.split(',')
        users = []
        members.each do |member|
          user = User.find_by(id: member.to_i)
          users << {username: user.username, img_path: user.img_path}
        end
        teams << users

        winner = users if result.win == 1
      end
    end
    matches_array << {team: teams, time: time, winner: winner, type: type}
  end
  matches_array
end


def build_most_active_array
  users = User.all
  matches_array = []

  users.each do |user|
    username = user.username
    img_path = user.img_path
    singles = user.singles_total_plays
    doubles = user.doubles_total_plays
    total = singles + doubles

    if total > 0
      matches_array << {username: username, img_path: img_path, singles: singles, doubles: doubles, total: total} 
    end
  end
  
  matches_array
end

