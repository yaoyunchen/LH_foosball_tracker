class UsersImporter

  def initialize(filename=File.absolute_path('db/data/users.csv'))
    @filename = filename
  end

  def import
    field_names = ['username', 'email', 'password', 'img', 'bio']
    puts "Importing users from '#{@filename}'."
    failure_count = 0
    User.transaction do 
      File.open(@filename).each do |line|
        data = line.chomp.split(',')

        attribute_hash = Hash[field_names.zip(data)]
        begin
          User.create!(attribute_hash)
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
    failures = failure_count > 0 ? "(failed to create #{failure_count} user records)" : ''
    puts "\nDONE #{failures}\n\n"
  end

end
