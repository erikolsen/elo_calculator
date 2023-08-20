source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass'
gem 'sass-rails', '~> 5.0.0'
# Use Uglifier as compressor for JavaScript assets
# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'foundation-rails', '~> 6.4.1.3'
gem 'chart-js-rails'
gem 'hamlit'

gem 'turbolinks'

# For heroku
gem 'rails_12factor', group: :production

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use puma as the app server
 gem 'puma-heroku'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'kaminari'

# Adds table information to top of model files
gem 'annotate'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development do
  #gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rack-mini-profiler'
  # For memory profiling (requires Ruby MRI 2.1+)
  gem 'memory_profiler'
  # # For call-stack profiling flamegraphs (requires Ruby MRI 2.0.0+)
  gem 'flamegraph'
  gem 'stackprof'     # For Ruby MRI 2.1+
  gem 'fast_stack'    # For Ruby MRI 2.0
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test, :development do
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'pry-byebug'
  gem 'faker'
  gem 'factory_bot_rails'
end

group :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end

ruby '3.2.2'
