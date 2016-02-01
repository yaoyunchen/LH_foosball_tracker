helpers do
  enable :sessions
  def current_user
    current_user = User.find_by(id: session[:user_id])
  end
end


# Homepage (Root path)
get '/' do
  redirect '/leaderboard'
end

#Goes to the rules/introduction page.
get '/intro' do
  erb :'intro'
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

post '/dev/match' do
  p params
  redirect '/dev/match'
end

get '/dev/match/doubles-selection' do
  erb :'/dev/match/doubles_selection'
end

post '/dev/match/doubles-selection' do
  p params
  redirect '/dev/match/doubles-selection'
end

put '/dev/match/requests' do
  p params
  redirect '/dev/match/requests'
end

put '/dev/match/pending' do
  p params
  redirect '/dev/match/pending'
end