get '/user' do 
  erb :'user/index'
end


#Get a form to request a match when the '+' is pressed while selecting opponent(s).
get '/user/match_request/new' do
  redirect '/users/login' unless current_user
  @users = User.all
  erb :'match_request/new'
end

#Submits form for requesting a match.
post '/user/match_request' do
  params[:teammate] ? type = "doubles" : type = "singles"
  
  message = params[:message]   #Trash talk some shit.

  player_array = []

  if type =="singles"
    player_array << {user_id: params[:user2], side: 1}
  else
    player_array << {user_id: params[:user2], side: 2} 

    player_array << {user_id: params[:user2], side: 2} 
    
    player_array << {user_id: params[:user2], side: 2} 

    player_array.each do |ele|
      ele[:side] = 1 if ele[:user_id] == params[:teammate]
    end
  end

  current_user.issue_request(player_array, type, message)

  #Should redirect to pending page.
  redirect '/'
end


####################


#Gets a list of invites sent to the user.
get '/user/match_invites' do
  redirect '/users/login' unless current_user
  
  invites = current_user.match_invites.where(accept: nil).order(match_request_id: :desc)
  
  @invite_array = []

  invites.each do |invite|
    id = invite.id
    team = invite.team
    issuer = ""
    match_type = ""
    message = ""
    left_players = ""
    right_players = ""

    request = MatchRequest.find_by(id: invite.match_request_id)
    
    issuer = request.user.username
    match_type << request.category
    message << request.message if request.message 
    
    player_array = MatchInvite.where(match_request_id: request.id)
    

    team_left = player_array.where(team: team)
    players_left = []
    team_left.each do |member|
      player = User.find_by(id: member.user_id)
      players_left << {username: player.username, img_path: player.img_path}
    end

    team_right = player_array.where.not(team: team)
    players_right = []
    team_right.each do |member|
      player = User.find_by(id: member.user_id)
      players_right << {username: player.username, img_path: player.img_path}
    end

    info = {
      id: id,
      team: team,
      issuer: issuer,
      match_type: match_type,
      message: message,
      left_players: players_left,
      right_players: players_right
    }

    @invite_array << info
  end
  @invite_array

  erb :'user/match_invites/index'
end

# #Gets a notification to accept or decline a specific invite in the invites list.
get '/user/match_invites/:match_invite_id' do
  redirect '/users/login' unless current_user
end

#Submits a form for accepting or declining a specific invite in the invites list.
put '/user/match_invites/:match_invite_id' do
  @match_invite = MatchInvite.find params[:match_invite_id]
  
  @match_invite.update!(accept: params[:choice])

  redirect '/'
end


####################


#Show user's pending matches.
get '/user/pending_matches' do
  redirect '/users/login' unless current_user

  matches = current_user.match_results.where(result: nil)

  @match_hash_array = []
  
  matches.each do |match|
    team = match.team
    other_players = MatchResult.where(match_id: match.match_id).where.not(user_id: current_user.id)
    other_players.count == 1 ? type = "singles" : type = "doubles"

    others_array = []
    other_players.each do |result|
      player = User.find_by(id: result.user_id)
      others_array << {username: player.username, img_path: player.img_path, team: result.team}
    end
    others_array

    result = {
      match_id: match.match_id,
      other_players: others_array,
      accepted_on: match.match.created_at,
      type: type, 
      team: team
    }
    @match_hash_array << result
  end

  @match_hash_array

  erb :'user/pending_matches/index'
end

# #Shows a form to let user's end a match either from cancelling or selecting a winner.
# get '/user/pending_matches/:match_id/edit' do


# end

#Submits a form for accepting or declining a specific invite in the invites list.
put '/user/pending_matches/:match_id' do
  redirect '/users/login' unless current_user

  @match = Match.find params[:match_id]

  choice = params[:choice]  #"cancelled"

  if choice == "cancelled"
    @match.match_cancelled
  else
    redirect "/user/pending_matches/#{params[:match_id]}/choose_winner"
  end

  redirect '/'
end

get '/user/pending_matches/:match_id/choose_winner' do
  redirect '/users/login' unless current_user

  match = Match.find params[:match_id]
  team_left = MatchResult.where(match_id: match.id ,user_id: current_user.id)
  players_left = []
  team_left.each do |member|
    player = User.find_by(id: member.user_id)
    players_left << {username: player.username, img_path: player.img_path, team: member.team}
  end

  team_right = MatchResult.where.not(team: team_left[0].team).where(match_id: match.id)
  players_right = []
  team_right.each do |member|
    player = User.find_by(id: member.user_id)
    players_right << {username: player.username, img_path: player.img_path, team: member.team}
  end

  @result = {left: players_left, right: players_right, id: match.id}

  erb :'user/pending_matches/choose_winner'
end


put '/user/pending_matches/:match_id/choose_winner/edit' do
  @match = Match.find params[:match_id]
  @match.match_over(params[:team])
  redirect '/'
end