get '/user' do 
  erb :'user/index'
end


#Get a form to request a match when the '+' is pressed while selecting opponent(s).
get '/user/match/singles/new' do
  redirect '/users/login' unless current_user
  
  users = User.where.not(id: current_user.id)
  @players_array = []

  users.each do |user|
    @players_array << {
      id: user.id,
      username: user.username,
      img_path: user.img_path,
      wins: user.singles_wins,
      losses: user.singles_losses,
      ratio: user.singles_ratio 
    }
  end

  @players_arrays

  erb :'match/singles/new'
end

#Submits form for requesting a match.
post '/user/match/singles/new' do
  type = "singles"
  
  message = params[:message]   #Trash talk some shit.

  player_array = [{user_id: params[:user2], side: 1}]
  
  current_user.issue_match(player_array, message)

  #Should redirect to pending page.
  redirect '/'
end


get '/user/match/doubles/new' do
  redirect '/users/login' unless current_user
  
  users = User.where.not(id: current_user.id)
  @players_array = []

  users.each do |user|
    @players_array << {
      id: user.id,
      username: user.username,
      img_path: user.img_path,
      wins: user.doubles_wins,
      losses: user.doubles_losses,
      ratio: user.doubles_ratio 
    }
  end

  @players_arrays

  erb :'match/doubles/new'
end


#Submits form for requesting a match.
post '/user/match/doubles/new' do 
  message = params[:message]   #Trash talk some shit.

  player_array = []

  player_array << {user_id: params[:user2], side: 2} 

  player_array << {user_id: params[:user2], side: 2} 
  
  player_array << {user_id: params[:user2], side: 2} 

  player_array.each do |ele|
    ele[:side] = 1 if ele[:user_id] == params[:teammate]
  end

  current_user.issue_match(player_array, message)

  #Should redirect to pending page.
  redirect '/'
end



####################



#Gets a list of invites sent to the user.
get '/user/match_invites' do
  redirect '/users/login' unless current_user
  
  invites = current_user.match_invites.where(accept: nil).order(match_id: :desc)
  
  @invite_array = []

  invites.each do |invite|
    id = invite.id
    side = invite.side
    issuer = ""
    category = ""
    message = ""
    sent = ((Time.now - invite.created_at)/86400).to_i

    match = Match.find_by(id: invite.match_id)
    
    issuer = match.user.username
    img_path = match.user.img_path
    category = match.category
    message << match.message if match.message 

    @invite_array << {
      id: id,
      side: side,
      issuer: issuer,
      img_path: img_path,
      category: category,
      message: message, 
      sent: sent
    }
  end
  @invite_array

  erb :'/user/match_invites/index'
end


#Submits a form for accepting or declining a specific invite in the invites list.
put '/user/match_invites' do
  @match_invite = MatchInvite.find(params[:match_invite_id].to_i)
  match_id = @match_invite.match_id

  p params
  if params[:accept] == "true"
    current_user.accept_invite(match_id)
  else
    current_user.decline_invite(match_id)
  end

  erb :'/'
end


####################

get '/user/pending_invites' do
  erb :'/user/pending_invites/index'
end


put '/user/pending_invites' do

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