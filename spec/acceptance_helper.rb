require 'rails_helper'
require 'rspec/page-regression'
require 'capybara/poltergeist'
require "rack_session_access/capybara"
require "puma"

module OneConnection
  class << self
    attr_accessor :connection
  end

  module Connection
    def connection
      OneConnection.connection || super
    end
  end

  module Ext
    extend ActiveSupport::Concern

    included do
      class << self
        prepend OneConnection::Connection
      end
    end
  end
end

OneConnection.connection = ActiveRecord::Base.connection

ActiveRecord::Base.send(:include, OneConnection::Ext)

RSpec.configure do |config|
  include ActionView::RecordIdentifier
  config.include AcceptanceHelper, type: :feature

  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = 3001 + ENV['TEST_ENV_NUMBER'].to_i
  Capybara.default_max_wait_time = 2
  Capybara.save_path = "./tmp/capybara_output"
  Capybara.always_include_port = true # for correct app_host

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90, js_errors: true,
      phantomjs_logger: Logger.new(STDOUT),
      window_size: [1020, 740]
    )
  end

  Capybara.javascript_driver = :poltergeist

  Capybara.server = :puma

  RSpec::PageRegression.configure do |c|
    c.threshold = 0.01
  end

  # config.before(:each, type: :feature) { Capybara.app_host = "http://dev.#{Capybara.server_host}.xip.io" }

  config.after(:each) { Timecop.return }

  config.append_after(:each) do
    Capybara.reset_sessions!
  end
end
