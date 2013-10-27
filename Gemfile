if ENV['TRAVIS'] || ENV['CI']
    source 'https://rubygems.org'
else
    source 'http://ruby.taobao.org'
end

gem 'bindata'

gem 'nokogiri'
gem 'haml'

group :test do
    gem 'rake'
    gem 'rspec'
    gem 'coveralls', require: false
end
