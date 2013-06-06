#require File.expand_path('../NothingForTheTimeBeing', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'stringio'
require 'digest/md5'
require 'lol_model_format.rb'
include LolModelFormat

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end