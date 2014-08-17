ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::JUnitReporter.new]
require 'database_cleaner'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  DatabaseCleaner.strategy = :transaction

  # Add more helper methods to be used by all tests here...

  include FactoryGirl::Syntax::Methods
end

class MiniTest::Spec
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  OmniAuth.config.test_mode = true
  Capybara.javascript_driver = :poltergeist
  Capybara.current_driver = :poltergeist
  self.use_transactional_fixtures = false

  require 'integration_test_helper'

  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end

  register_spec_type(/integration$/i, self)
end
