source 'https://rubygems.org'
ruby '2.1.2'
# ruby ENV['BUNDLE_RUBY_VERSION'] || '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'

if ENV['RDS_DB_NAME']
  # Use mysql2 as the database for Active Record
  gem 'mysql2'
else
  # Use postgresql as the database for Active Record
  gem 'pg', :group=>:staging
  gem 'mysql2', :group=>[:development, :test]
end
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Allow Heroku to serve static assets
gem 'rails_12factor', group: [:staging, :production]

# Store sessions in database
gem 'activerecord-session_store'#, github: 'rails/activerecord-session_store'

# Quiet asset loading
gem 'quiet_assets', group: :development

# Use Bootstrap 3
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'

# Use encryption
gem 'bcrypt'

# Avatars, images, and other attachements
gem "paperclip", "~> 4.2"
# Save attachments in S3
gem "aws-sdk"

# upload files
gem 'jquery-fileupload-rails'

# pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# email development
gem 'letter_opener', :group=>[:development]

# better select boxes
gem 'bootstrap-select-rails'

# REST requests
gem 'rest-client'

# Test mocking
gem 'mocha', :group=>:test

# Paypal
gem 'paypal-sdk-rest', "~>1.1"
gem 'paypal-sdk-adaptivepayments'
#gem 'paypal-sdk-permissions'
