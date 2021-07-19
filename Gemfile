# frozen_string_literal: true

required_bundler_version = Gem::Version.new("2.2.23")
current_bundler_version = Gem::Version.new(Bundler::VERSION)

current_bundler_version < required_bundler_version &&
  abort(
    "Bundler version >= #{required_bundler_version} is required, "\
    "but running #{current_bundler_version}"
  )

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.4"

# https://github.com/rails-api/active_model_serializers/tree/0-10-stable
gem "active_model_serializers", "~> 0.10.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3.6"
# For HackerRank compatibility
gem "sprockets", "~> 3.7.2"
# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4.2"

# Use Puma as the app server
gem "puma", "~> 5.3"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"

  gem "rspec-scaffold", "2.0.0.beta1"
  gem "rubocop", "~> 1.18.3", require: false
  gem "rubocop-rails", "~> 2.11", require: false
  gem "rubocop-rspec", "~> 2.4", require: false

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring", "~> 2.1"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :development, :test do
  gem "bullet", ">= 6.1"
  gem "pry-rails", ">= 0.3"
  gem "rspec_junit_formatter", "~> 0.4"
  gem "rspec-rails", "~> 5.0"
end

group :test do
  gem "factory_bot_rails", "~> 6.2"
  gem "shoulda-matchers", "~> 5.0", require: false
  gem "simplecov", "~> 0.21", require: false
end
