# Run the tests with:
#     rspec plugins/kanbine/test/whatever/my_tests.rb
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'rspec/rails'
require 'active_record/fixtures'
require 'pry'
# Require all the files in the helpers directory.
# The methods declared in the Helpers module will be included in RSpec
# TODO Allow subfolders
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each do |file|
  require_relative 'helpers/' + file.split('/')[-1].split('.')[0]
end

Capybara.default_driver = :poltergeist
Capybara.default_max_wait_time = 6

RSpec.configure do |c|
  c.include Helpers
  c.use_transactional_fixtures = true
end
