ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start
require_relative 'dummy/config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
end
