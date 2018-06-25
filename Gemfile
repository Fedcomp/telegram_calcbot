source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.5.1"

gem "puma", "~> 3.7"
gem "rails", "~> 5.2.0"

# rails 5.2 compatibility
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "rubocop"

  gem "guard"
  gem "guard-bundler"
  gem "guard-rspec"
end

group :development, :test do
  gem "pry-byebug"
  gem "pry-rails"

  # in both groups because contain generators
  gem "rspec-rails"
end

group :test do
  gem "webmock"
  gem "faker"
end
