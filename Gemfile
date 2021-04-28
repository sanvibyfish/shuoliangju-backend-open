source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
# gem "pg"
gem "mysql2"

# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'devise'
gem 'devise_invitable'
gem "devise-i18n"
gem 'rails-i18n', '~> 6.0.0' # For 6.0.0 or higher

gem "slim-rails"
gem 'simple_form'
gem 'config'
gem 'jwt'
gem 'rack-cors'
gem "activestorage-aliyun", :tag => "v0.6.4"
gem 'simplecov', require: false, group: :test
gem 'rest-client', '~> 2.1'
gem 'nokogiri'
gem 'dotenv-rails'
gem 'wechat', git: 'https://github.com/sanvibyfish/wechat', :branch => 'master'

#breadcrumb
gem 'loaf'

gem 'action-store'

#分页
gem 'kaminari'

#Redis
gem "connection_pool"
gem "hiredis"
gem "redis"
gem "redis-namespace"
gem "redis-objects"

#权限
gem 'cancancan'

gem "exception-track"

#队列
gem 'sidekiq'


# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem "actiontext-lite"

#搜索
gem 'ransack'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'rspec-rails', '4.0.0.beta3'
  gem 'guard-rspec', require: false
  gem "fakeredis", :require => "fakeredis/rspec"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'factory_bot_rails'
  gem 'guard-spork'
  gem 'spork', '~> 1.0rc'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
