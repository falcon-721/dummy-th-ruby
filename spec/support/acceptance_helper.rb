module AcceptanceHelper
  def sign_in(user)
    page.set_rack_session(
      'warden.user.user.key' =>
      User.serialize_into_session(user).unshift("User")
    )
  end

  def save_screenshot(name = nil)
    path = name || "screenshot-#{Time.now.utc.iso8601.delete('-:')}.png"
    page.save_screenshot path
    File.join(Capybara.save_path, path)
  end

  # Wait materialize-css animation completes
  def wait_animation
    sleep 0.2
  end

  def switch_subdomain(name = "dev")
    host = "#{name}.#{Capybara.server_host}.xip.io"
    Capybara.app_host = "http://#{host}"
  end

  def switch_hostname(host)
    Capybara.app_host = "http://#{host}"
  end

  def with_hidden_fields
    Capybara.ignore_hidden_elements = false
    yield
    Capybara.ignore_hidden_elements = true
  end

  def attach_hidden_files(locator, *files)
    with_hidden_fields do
      files.each do |path|
        find(locator).set path
      end
    end
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
