source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap',                 '>= 1.1.0', require: false
gem 'json-jwt',                 '~> 1.9.4'
gem 'newrelic_rpm',             '~> 5.2.0'
gem 'oj',                       '~> 3.6.0'
gem 'pg',                       '~> 1.0.0'
gem 'puma',                     '~> 3.11'
gem 'rails',                    '~> 5.2.0'
gem 'sentry-raven',             '~> 2.7.3'

group :development, :test do
  gem 'byebug',                 '~> 10.0.2', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen',                 '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen',  '~> 2.0.0'
end

group :test do
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'minitest-spec-rails'
  gem 'mocha'
  gem 'rubocop', require: false
  gem 'webmock'
end
