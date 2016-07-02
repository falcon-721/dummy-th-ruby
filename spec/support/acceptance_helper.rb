module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def save_screenshot(name = nil)
    path = File.join(
      Capybara.save_and_open_page_path,
      name || "screenshot-#{Time.now.utc.iso8601.delete('-:')}.png"
    )
    page.save_screenshot path
  end

  # Wait materialize-css animation completes
  def wait_animation
    sleep 0.2
  end

  # Opens test server (using launchy), authorize as user (if provided)
  # and wait for specified time (in seconds) until continue spec execution
  #
  # If you specify 0 as 'wait' you should manually resume spec execution.
  def visit_server(user: nil, wait: 2, path: '/')
    url = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    if user.present?
      url += "/dev/log_in/#{user.id}?redirect_to=#{path}"
    else
      url += path
    end

    p "Visit server on: #{url}"
    Launchy.open(url)
    
    if wait == 0
      p "Type any key to continue..."
      $stdin.gets
      p "Done."
    else
      sleep wait
    end
  end
end
