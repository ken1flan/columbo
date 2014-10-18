source 'https://rubygems.org'
ruby "2.1.1"

gem 'rails', '4.1.6'
gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
gem 'twitter-bootstrap-rails'
gem 'zurui-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
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
gem 'cancancan', '~> 1.9'

# いいね
gem 'activerecord-reputation-system', github: 'NARKOZ/activerecord-reputation-system', branch: 'rails4'

gem "chartkick"             # グラフ

group :development do
  gem 'rails-footnotes', '>= 4.0.0', '<5'
  gem 'better_errors'
  gem 'letter_opener'
  gem "annotate"            # テーブル定義を各種ファイルに貼り付ける
  gem "squasher"            # migrationファイルの圧縮
end

group :test do
  gem 'minitest-spec-rails' # describeやitが使える
  gem 'minitest-matchers'   # いろいろなmatcher
  gem 'minitest-reporters'  # minitestの実行結果をキレイに見せる
  gem 'capybara'            # integration testでブラウザ上の操作を記述できるようにする
  gem 'poltergeist'         # capybaraのjsdriver。phantomjsを使う。
  gem 'database_cleaner'    # テスト時にdbのクリーンアップする方法を選択しやすくする。
  gem 'timecop'             # 時間を止めたり、変えたりする。
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-byebug'
  gem 'sqlite3'
  gem 'factory_girl_rails'  # fixturesより細やかなデータを記述できる
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end
