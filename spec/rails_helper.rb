require 'simplecov'
require 'simplecov-csv'
SimpleCov.start do
  SimpleCov.coverage_dir(ENV['COVERAGE_REPORTS'])
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter::new [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CSVFormatter
  ]

  SimpleCov.add_filter '/spec/'
  SimpleCov.add_filter '/config/'

  SimpleCov.add_group 'Controllers', 'app/controllers'
  SimpleCov.add_group 'Models', 'app/models'
  SimpleCov.add_group 'Helpers', 'app/helpers'
  SimpleCov.add_group 'Libraries', 'lib/'

  # SimpleCov.merge_timeout(600)
  SimpleCov.use_merging(true)
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'support/controller_macros'
RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  # config.infer_spec_type_from_file_location!

  config.include AuthHelpers, type: :controller


end
