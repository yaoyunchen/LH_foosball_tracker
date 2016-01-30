helpers do
  enable :sessions
  def current_user
    current_user = User.find_by(id: session[:user_id])
  end
end


# Homepage (Root path)
get '/' do
  @limit = 2

  user_ids = MatchResult.group(:user_id).sum("CASE WHEN result=1 THEN 1 ELSE 0 END")
  user_ids = user_ids.sort_by{|key, value| value}.to_h

  @users = []
  user_ids.each do |key, value|
    @users << User.find(key)
  end

  
  players = []
  @last_matches = Match.where(status: "over").last(@limit)
  
  # last_matches.each do |match|
    
  #   players << MatchResult.where(match_id: match.id) 



  #   players.each do |player|
  #     team = players.first.team
  #     team_left = players.where(team: 1) 
  #     team_right = players.where.not(team: 1) 

  #     @team_left_player_names = ""
  #     team_left.each do |player|
  #       @team_left_player_names <<  User.find(player.user_id).username
  #     end
    
  #     @team_right_player_names = ""
  #     team_right.each do |player|
  #       @team_right_player_names <<  User.find(player.user_id).username
  #     end
  #   end
    

  # end





  erb :index
end



# Development

get '/dev/match' do
  erb :'/dev/match/index'
end

get '/dev/match/requests' do
  erb :'/dev/match/requests'
end

get '/dev/match/pending' do
  erb :'/dev/match/pending'
end

get '/dev/match/record' do
  erb :'/dev/match/record'
end

get '/dev/match/select_winner' do
  erb :'/dev/match/select_winner'
end

get '/dev/match/match_saved' do
  erb :'/dev/match/match_saved'
end

get '/dev/match/challenge_issued' do
  erb :'/dev/match/challenge_issued'
end

get '/dev/match/accepted-notification' do
  erb :'/dev/match/accepted_notification'
end

get '/dev/match/add-player' do
  erb :'/dev/match/add_player'
end

get '/dev/match/add-players' do
  erb :'/dev/match/add_players'
end

get '/dev/rules' do
  erb :'/dev/rules/index'
end

get '/dev/leaderboard' do
  erb :'/dev/leaderboard/index'
end