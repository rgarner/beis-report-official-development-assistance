# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "2.6.3"

gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap", ">= 4.3.1"
gem "coffee-rails", "~> 5.0"
gem "haml-rails"
gem "high_voltage"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "pg"
gem "mini_racer"
gem "puma", "~> 4.1"
gem "rollbar"
gem "rails", "~> 6.0.1"
gem "sassc", "~> 2.0.1" # Downgrade to fix https://github.com/sass/sassc-ruby/issues/133
gem "sass-rails", "~> 6.0"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "uglifier", ">= 1.3.0"
gem "simple_form"

# Authentication
gem "omniauth-auth0", "~> 2.2"
gem "omniauth-rails_csrf_protection", "~> 0.1"

group :development do
  gem "listen", ">= 3.0.5", "< 3.3"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "chromedriver-helper"
  gem "selenium-webdriver"
  gem "rack_session_access"
  gem "webmock", "~> 3.5"
end

group :development do
  gem "better_errors"
  gem "html2haml"
  gem "rails_layout"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "i18n-tasks", "~> 0.9.29"
  gem "rspec-rails"
  gem "standard"
  gem "pry"
end

group :test do
  gem "database_cleaner"
  gem "launchy"
  gem "shoulda-matchers"
end
