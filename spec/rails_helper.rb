# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'action_cable/testing/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join("spec/shared_contexts/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/shared_examples/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

# Setup ActionCable test adapter
server = ActionCable.server
test_adapter = ActionCable::SubscriptionAdapter::Test.new(server)
server.instance_variable_set(:@pubsub, test_adapter)

module RSpecBenchWorld
  def ordered_example_groups
    @example_groups = @example_groups * Nenv.bench.to_i
    super
  end
end

RSpec::Core::World.prepend(RSpecBenchWorld) if Nenv.bench?

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include EmailSpec::Helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!

  config.infer_spec_type_from_file_location!

  config.after(:each) do
    ActionCable.server.pubsub.try(:reset!)
  end

  config.after(:suite) do
    FileUtils.rm_rf Rails.root.join("public/uploads#{ENV['TEST_ENV_NUMBER'] || ''}")
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
