require "active_record"
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "en_masse_test",
  password: nil,
  pool: 5,
  encoding: "unicode",
  min_messages: "warning"
)

begin
  ActiveRecord::Base.connection
rescue ActiveRecord::NoDatabaseError => e
  puts "Test database doesn't exist. It can be created with:"
  puts
  puts "  rake db:create"
  exit 1
end

RSpec.configure do |rspec|
  rspec.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
