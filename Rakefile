require 'rake'
require "sinatra/activerecord/rake"
require ::File.expand_path('../config/environment', __FILE__)


desc "create the database"
task "db:create" do
  touch 'db/db.sqlite3'
end

desc "drop the database"
task "db:drop" do
  rm_f 'db/db.sqlite3'
end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end

task "all" do
  Rake::Task["db:create"].invoke
  Rake::Task["db:drop"].invoke
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:seed"].invoke
end

desc 'compile jquery files'
task "js:compile" do

  paths = []
  paths << 'assets/js/_main_nav.js'
  paths << 'assets/js/_select_players_to_invite.js'
  paths << 'assets/js/_respond_to_invite.js'
  paths << 'assets/js/_record_match.js'

  File.open('public/javascript/application.js', 'w') do |file|

    file.puts '$(document).ready(function() {'

    paths.each do |path|
      content = File.read(path)
      file.puts content
    end

    file.puts '});'

  end

end