source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'slim-rails'
gem 'devise'
gem 'pry'
gem 'active_decorator'
gem 'annotate'
gem 'semantic-ui-sass'
gem 'active_decorator-rspec'
gem 'jp_prefecture'
gem 'kaminari'
gem 'carrierwave'
gem 'rmagick'
gem 'seedbank'
gem 'google-analytics-rails'
gem 'capybara', '~> 2.13'
gem 'selenium-webdriver'
gem 'chromedriver-helper'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'test-queue' # Rspecの並列実行を実現するためのGem
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard-rspec', require: false # guardでrspecを動かす
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard' # デスクトップ通知を行う
  gem 'bullet'
end

group :test do
  gem 'database_cleaner', '~> 1.3.0' # テスト実行後にDBをクリア
  gem 'simplecov', require: false # テストカバレッジ(テストカバー率)
  gem 'email_spec' # メール送信系のカスタムマッチャを提供
end

group :production do
  gem 'pg'
  gem 'fog', '1.42'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
