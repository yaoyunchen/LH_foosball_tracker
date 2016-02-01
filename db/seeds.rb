def convert_to_yml(yml_file)
 YAML.load_file(File.absolute_path(yml_file))
end

user_yml = convert_to_yml('db/data/users.yml')

user_yml.each_pair do |name, info|
 User.create!(
   username: name,
   email: info["email"],
   password: info["password"],
   img_path: info["img_path"],
   bio: info["bio"]
 )
end

@users = User.all

Timecop.scale(10000)

#singles Matches
rand(10..25).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  opponents = [{user_id: opp1.id, side: 2}]
  player.issue_match(opponents)
  match_id = Match.last.id
  opp1.accept_invite(match_id)
  @match = Match.last
  winner = [1,2].sample
  @match.match_over(winner)
end

## Doubles Matches
rand(10..25).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  ex2 = User.all.reject{ |e| e == player || e == opp1}
  opp2 = ex2.sample
  ex3 = User.all.reject{ |e| e == player || e == opp1 || e == opp2 }
  opp3 = ex3.sample
  opponents = [{user_id: opp1.id, side: 1}, {user_id: opp2.id, side: 2}, {user_id: opp3.id, side: 2}]
  player.issue_match(opponents)
  match_id = Match.last.id
  opp1.accept_invite(match_id)
  opp2.accept_invite(match_id)
  opp3.accept_invite(match_id)
  @match = Match.last
  teamA = [player.id, opp1.id].sort
  teamB = [opp2.id, opp3.id].sort
  winner = [teamA, teamB].sample
  win = "#{winner[0]},#{winner[1]}"
  @match.match_over(win)
end

rand(10..25).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  opponents = [{user_id: opp1.id, side: 2}]
  player.issue_match(opponents)
  match_id = Match.last.id
  opp1.accept_invite(match_id)
  @match = Match.last
  winner = [1,2].sample
  @match.match_over(winner)
end

rand(10..25).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  ex2 = User.all.reject{ |e| e == player || e == opp1}
  opp2 = ex2.sample
  ex3 = User.all.reject{ |e| e == player || e == opp1 || e == opp2 }
  opp3 = ex3.sample
  opponents = [{user_id: opp1.id, side: 1}, {user_id: opp2.id, side: 2}, {user_id: opp3.id, side: 2}]
  player.issue_match(opponents)
  match_id = Match.last.id
  opp1.accept_invite(match_id)
  opp2.accept_invite(match_id)
  opp3.accept_invite(match_id)
  @match = Match.last
  teamA = [player.id, opp1.id].sort
  teamB = [opp2.id, opp3.id].sort
  winner = [teamA, teamB].sample
  win = "#{winner[0]},#{winner[1]}"
  @match.match_over(win)
end

rand(1..6).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  opponents = [{user_id: opp1.id, side: 2}]
  player.issue_match(opponents)
  match_id = Match.last.id
  opp1.accept_invite(match_id)
  @match = Match.last
  winner = [1,2].sample
  @match.match_over(winner)
end

rand(1..3).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  ex2 = User.all.reject{ |e| e == player || e == opp1}
  opp2 = ex2.sample
  ex3 = User.all.reject{ |e| e == player || e == opp1 || e == opp2 }
  opp3 = ex3.sample
  opponents = [{user_id: opp1.id, side: 1}, {user_id: opp2.id, side: 2}, {user_id: opp3.id, side: 2}]
  player.issue_match(opponents)
  match_id = Match.last.id
  opp1.accept_invite(match_id)
  opp2.accept_invite(match_id)
  opp3.accept_invite(match_id)
  @match = Match.last
  teamA = [player.id, opp1.id].sort
  teamB = [opp2.id, opp3.id].sort
  winner = [teamA, teamB].sample
  win = "#{winner[0]},#{winner[1]}"
  @match.match_over(win)
end

rand(1..3).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  opponents = [{user_id: opp1.id, side: 2}]
  player.issue_match(opponents)
  match_id = Match.last.id
  opp1.accept_invite(match_id)
  @match = Match.last
  winner = [1,2].sample
  @match.match_over(winner)
end

Timecop.travel(Date.today - 1)

# Unaccpted Invites Single
@nick = User.find(13)
rand(1..3).times do
 ex = User.all.reject{ |e| e == @nick}
 player = ex.sample
 opponents = [{user_id: @nick.id, side: 2}]
 player.issue_match(opponents)
end

# Unaccpted Invites Double
rand(1..3).times do
  player = @users.sample
  ex = User.all.reject{ |e| e == player}
  opp1 = ex.sample
  ex2 = User.all.reject{ |e| e == player || e == opp1}
  opp2 = ex2.sample
  opponents = [{user_id: opp1.id, side: 1}, {user_id: opp2.id, side: 2}, {user_id: @nick.id, side: 2}]
  player.issue_match(opponents)
end

Timecop.return