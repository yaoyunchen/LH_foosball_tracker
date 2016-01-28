
user_yml = YAML.load_file(File.absolute_path('db/data/users.yml'))

user_yml.each_pair do |name, info|
  User.create!(
    username: name,
    email: info["email"],
    password: info["password"],
    img: info["img"],
    bio: info["bio"]
  )
end

request_yml = YAML.load_file(File.absolute_path('db/data/requests.yml'))

request_yml.each_pair do |id, info|
  Request.create!(
    user_id: id,
    recipient_id: info["recipient_id"],
    status: info["status"],
    message: info["message"]
  )
end

match_yml = YAML.load_file(File.absolute_path('db/data/matches.yml'))

match_yml.each_pair do |id, info|
  Match.create!(
    request_id: id,
    user1_id: info["user1_id"],
    user2_id: info["user2_id"],
    winner_id: info["winner_id"],
    loser_id: info["loser_id"],
    status: info["pending"]
  )
end


