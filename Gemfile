source 'https://rubygems.org'
ruby '1.9.3'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.4'

gem 'sass-rails', '>= 3.2'
gem 'bootstrap-sass', '~> 3.1.1'


group :development, :test do 
	gem 'rspec-rails' 
	gem 'factory_girl_rails'
	gem 'pg', '0.15.1'
end 

group :test do 
	gem 'faker' 
	gem 'capybara' 
	gem 'guard-rspec' 
	gem 'launchy' 
end


# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

gem 'annotate', '~> 2.6.3'