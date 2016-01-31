LIMIT = 10

get '/leaderboard' do

  singles_array = build_singles_array
  singles_array = singles_array.sort_by {|k| k[:ratio]}.reverse
  @singles = []
  count = 0
  singles_array.each do |element|
    if count <= LIMIT
      count += 1
      @singles << element
    end
  end
  @singles

  # latest_array = build_latest_array
  # @latest = []
  # count = 0
  # latest_array.each do |element|
  #   if count <= LIMIT
  #     count +=1
  #     @latest << element
  #   end
  # end
  # @latest 

  # most_active_array = build_most_active_array
  # @actives = most_active_array

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
      ratio: user.singles_ratio
    }
    players_info_array << user_info
  end
  players_info_array



  # singles = get_singles
  # singles_array = []
  # singles[:user].each do |user|
  #   player = User.find_by(id: user)
  #   user_info = {
  #     username: player.username,
  #     wins: player.get_wins(singles[:matches]),
  #     losses: player.get_losses(singles[:matches]),
  #     ratio: player.get_ratio(singles[:matches]),
  #     img_path: player.img_path
  #   }
  #   singles_array << user_info
  # end
  # singles_array
end

# def get_singles
#   singles_matches = MatchResult.group(:match_id).having("COUNT(user_id) == 2").count
#   matches = singles_matches.keys

#   user_ids = MatchResult.group(:user_id).having('match_id in (?)', matches).sum("CASE WHEN result=1 THEN 1 ELSE 0 END")

#   users = user_ids.keys

#   finished_matches = MatchResult.group(:match_id).having("COUNT(user_id) == 2 AND result IS NOT NULL").count
#   finished_matches = finished_matches.keys

#   result = {
#     user: users,
#     matches: finished_matches
#   }
# end


# def build_latest_array

#   latest_matches = Match.where(status: "over").order(updated_at: :desc)

#   matches_array = []
#   latest_matches.each do |match|
#     type = ""
#     winner = ""
#     random_player = MatchResult.find_by(match_id: match.id)
#     team_left = MatchResult.where(team: random_player.team, match_id: random_player.match_id)
#     players_left = []
#     team_left.each do |member|
#       player = User.find_by(id: member.user_id)
#       players_left << {username: player.username, img_path: player.img_path}
#     end

#     team_right = MatchResult.where.not(team: team_left[0].team).where(match_id: match.id)
#     players_right = []
#     team_right.each do |member|
#       player = User.find_by(id: member.user_id)
#       players_right << {username: player.username, img_path: player.img_path, team: member.team}
#     end

#     winner = team_left[0].result == 1 ? team_left[0].team : team_right[0].team
#     matches_array << {time: match.updated_at, left: players_left, right: players_right, winner: winner}
#   end
#   matches_array
# end



# def build_most_active_array
#   games = get_games
#   users = User.all
  
#   matches_array = []
#   users.each do |user|
#     singles = MatchResult.where('match_id in (?) and user_id = (?)', games[:singles], user.id).count
#     doubles = MatchResult.where('match_id in (?) and user_id = (?)', games[:doubles], user.id).count
#     total = singles + doubles

#     result = {
#       username: user.username,
#       img_path: user.img_path,
#       singles: singles,
#       doubles: doubles,
#       total: total
#     }

#     matches_array << result if result[:total] > 0
#   end
#   matches_array
#   erb :'leaderboard/index'
# end

# def get_games
#   singles_matches = MatchResult.group(:match_id).having("COUNT(user_id) == 2").count
#   singles = singles_matches.keys
  
#   doubles_matches = MatchResult.group(:match_id).having("COUNT(user_id) == 4").count
#   doubles = doubles_matches.keys

#   result = {
#     singles: singles,
#     doubles: doubles
#   }
# end

