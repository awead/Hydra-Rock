# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require "equivalent-xml"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  #config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{Rails.root.to_s}/spec/fixtures/ar"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.global_fixtures = :activities, :users

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"

  config.include Devise::TestHelpers, :type => :controller
end

# Helper method for our local fixtires
def fixture(file)
  File.new(File.join(File.dirname(__FILE__), 'fixtures', file))
end

# Helper method for fedora fixtures
def fedora_fixture(file)
  File.new(File.join(File.dirname(__FILE__), 'fixtures', 'fedora', file))
end

# Returns the full path to a sip
def sip(dir)
  File.join(File.dirname(__FILE__), 'fixtures', 'sips', dir)
end

# Image fixture
def image_fixture file
  File.new(File.join(File.dirname(__FILE__), 'fixtures', 'images', file))
end

# Video fixture
def video_fixture
  File.new(File.join(File.dirname(__FILE__), 'fixtures/sips/digital_video_sip/data/content_001_access.mp4'))
end

# Cleanup a given directory
def clean_dir dir
  FileUtils.rm_rf(dir) if File.exists?(dir)
  FileUtils.mkdir(dir)
end

module FactoryGirl
  def self.find_or_create(handle, by=:email)
    tmpl = FactoryGirl.build(handle)
    tmpl.class.send("find_by_#{by}".to_sym, tmpl.send(by)) || FactoryGirl.create(handle)
  end
end