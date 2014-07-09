source 'https://rubygems.org'
ruby "2.1.1"

gem 'rails', '4.1.0'
gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :branch => 'bootstrap3'
gem 'zurui-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
# gem 'bcrypt', '~> 3.1.7'
# gem 'unicorn'
# gem 'capistrano-rails', group: :development

gem 'twitter'
gem 'kaminari'

gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# いいね
gem 'activerecord-reputation-system', github: 'NARKOZ/activerecord-reputation-system', branch: 'rails4'

group :development do
  gem 'rails-footnotes', '>= 4.0.0', '<5'
  gem 'better_errors'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end
