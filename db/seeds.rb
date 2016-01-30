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
