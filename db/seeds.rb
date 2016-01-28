require_relative '../lib/users_importer.rb'
require_relative '../lib/requests_importer.rb'
require_relative '../lib/matches_importer.rb'
UsersImporter.new.import
RequestsImporter.new.import
MatchesImporter.new.import