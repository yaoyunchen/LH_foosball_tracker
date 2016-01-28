class MatchesImporter

  def initialize(filename=File.absolute_path('db/data/matches.csv'))
    @filename = filename
  end

  def import
    field_names = ['user1_id', 'user2_id', 'winner_id', 'loser_id', 'request_id', ]
    puts "Importing match from '#{@filename}'."
    failure_count = 0
    Match.transaction do 
      File.open(@filename).each do |line|
        data = line.chomp.split(',')

        attribute_hash = Hash[field_names.zip(data)]
        begin
          Match.create!(attribute_hash)
          print '.'
        rescue
          failure_count += 1
          print '!'
        ensure
          #Forces output to appear immediately, otherwise it may be stuck in buffer until enough output has been accumulated to be commited to the terminal.
          STDOUT.flush
        end
      end
    end
    failures = failure_count > 0 ? "(failed to create #{failure_count} match records)" : ''
    puts "\nDONE #{failures}\n\n"
  end

end
