require 'rails_helper'
require 'rspec/page-regression'
require 'capybara/poltergeist'

RSpec.configure do |config|
  include ActionView::RecordIdentifier
  config.include AcceptanceHelper, type: :feature

  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = 3001
  Capybara.default_wait_time = 2
  Capybara.save_and_open_page_path = "./tmp/capybara_output"

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90, js_errors: true,
      phantomjs_logger: Logger.new(STDOUT),
      window_size: [1020, 740]
    )
  end

  Capybara.javascript_driver = :poltergeist

  RSpec::PageRegression.configure do |config|
    config.threshold = 0.01
  end

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }

  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }

  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) { Timecop.return }

  config.after(:each) do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
