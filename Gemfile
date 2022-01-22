source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'rails', '~> 7.0.1'

gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test do
  gem 'simplecov', require: false
end
