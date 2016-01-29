# Homepage (Root path)
get '/' do
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
