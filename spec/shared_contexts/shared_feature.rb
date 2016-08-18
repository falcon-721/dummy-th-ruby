shared_context "feature", type: :feature do
  after(:each) do |example|
    next unless example.exception
    meta = example.metadata
    next unless meta[:js] == true
    filename = File.basename(meta[:file_path])
    line_number = meta[:line_number]
    screenshot_name = "screenshot-#{filename}-#{line_number}.png"
    path = save_screenshot(screenshot_name) # rubocop:disable Lint/Debugger
    puts "Failure screenshot: #{path}"
  end
end
