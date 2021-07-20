# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require "spec_helper"
require "cov_helper" if ENV["COV"]
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
Rails.application.eager_load! if ENV["COV"]

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
require "test_prof/recipes/rspec/let_it_be"

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
