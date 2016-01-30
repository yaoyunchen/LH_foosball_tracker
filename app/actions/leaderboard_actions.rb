get '/leaderboard' do

  @user_ids = MatchResult.group(:user_id).sum("CASE WHEN result=1 THEN 1 ELSE 0 END")

  @user_ids = @user_ids.sort_by{|key, value| value}.to_h
  
  @users = []

  @user_ids.each do |key, value|
    @users << User.find(key)
  end

  

  erb :'leaderboard/index'
end


