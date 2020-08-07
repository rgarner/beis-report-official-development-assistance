# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "2.6.3"

gem "auth0", "~> 4.14"
gem "acts_as_tree"
gem "bootsnap", ">= 1.1.0", require: false
gem "data_migrate"
gem "govuk_design_system_formbuilder", "~> 1.2.6"
gem "haml-rails"
gem "high_voltage"
gem "ipaddr"
gem "jbuilder", "~> 2.10"
gem "pg"
gem "mail-notify"
gem "monetize"
gem "mini_racer"
gem "parser", "~> 2.6.3.0"
gem "puma", "~> 4.3"
gem "public_activity", "~> 1.5"
gem "pundit"
gem "rollbar"
gem "rails", "~> 6.0.3"
gem "redis", "~> 4.2"
gem "redis-namespace"
gem "redis-actionpack"
gem "redis-store"
gem "sassc", "~> 2.4.0" # Downgrade to fix https://github.com/sass/sassc-ruby/issues/133
gem "sass-rails", "~> 6.0"
gem "sidekiq", "~> 5.2"
gem "skylight"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "uglifier", ">= 1.3.0"
gem "wicked"
gem "strip_attributes"

# Authentication
gem "omniauth-auth0", "~> 2.3"
gem "omniauth-rails_csrf_protection", "~> 0.1"

group :development, :test do
  gem "brakeman"
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "i18n-tasks", "~> 0.9.31"
  gem "rspec-rails"
  gem "standard"
  gem "pry-rails"
end

group :development do
  gem "better_errors"
  gem "html2haml"
  gem "listen", ">= 3.0.5", "< 3.3"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "rails_layout"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "climate_control"
  gem "coveralls", require: false
  gem "database_cleaner"
  gem "fakeredis", require: false
  gem "launchy"
  gem "pundit-matchers", "~> 1.6.0"
  gem "shoulda-matchers"
  gem "selenium-webdriver"
  gem "webmock", "~> 3.8"
end

group :production do
  gem "lograge"
end
