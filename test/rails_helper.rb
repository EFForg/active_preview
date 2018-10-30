# frozen_string_literal: true
ENV['RAILS_ENV'] = 'test'

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]

require 'rspec/rails'

SUPPORT_PATH = %w(spec support ** *.rb).freeze

Dir[Rails.root.join(*SUPPORT_PATH)].sort.each { |file| require file }

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  # DatabaseCleaner set up
  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end

ActiveRecord::Migration.maintain_test_schema!
