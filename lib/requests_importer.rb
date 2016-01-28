class RequestsImporter

  def initialize(filename=File.absolute_path('db/data/requests.csv'))
    @filename = filename
  end

  def import
    field_names = ['user_id', 'recipient_id', 'status', 'message']
    puts "Importing requests from '#{@filename}'."
    failure_count = 0
    Request.transaction do 
      File.open(@filename).each do |line|
        data = line.chomp.split(',')

        attribute_hash = Hash[field_names.zip(data)]
        begin
          Request.create!(attribute_hash)
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
    failures = failure_count > 0 ? "(failed to create #{failure_count} request records)" : ''
    puts "\nDONE #{failures}\n\n"
  end

end
