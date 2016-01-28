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



# match_request_yml = convert_to_yml('db/data/match_requests.yml')

# match_request_yml.each_pair do |id, info|
#   MatchRequest.create!(
#     user_id: id,
#     match_id: info["match_id"],
#     category: info["category"],
#     message: info["message"]
#   )
# end



# match_invite_yml = convert_to_yml('db/data/match_invites.yml')

# match_invite_yml.each_pair do |id, info|
#   MatchInvite.create!(
#     matchrequest_id: id,
#     user_id: info["user_id"],
#     team: info["team"],
#     accept: info["accept"]
#   )
# end


# match_yml = convert_to_yml('db/data/matches.yml')

# match_yml.each_pair do |id, info|
#   Match.create!(
#     matchrequest_id: id,
#     status: info["status"]
#   )
# end

# match_participaction = convert_to_yml('db/data/match_participactions.yml')
# match_participaction.each_pair do |id, info|
#   match_id: id,
#   user_id: info["user_id"],
#   team: info["team"],
#   result: info["result"]
# end
