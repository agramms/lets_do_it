source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# make it easy to securely configure Rails applications.
gem 'figaro'

# Secure Token
gem 'jwt'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1', '>= 6.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2', '>= 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 5.2', '>= 5.2.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  gem 'amazing_print'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '~> 3.4', '>= 3.4.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Code quality
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubycritic'

  # Security
  gem 'brakeman'
  gem 'bundler-audit', '~> 0.6'

  # Tool to manage and configure Git hooks
  gem 'overcommit', '~> 0.57.0'
end

group :test do
  gem 'factory_bot'
  gem 'faker', '~> 1.6', '>= 1.6.3'
  gem 'shoulda-matchers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
