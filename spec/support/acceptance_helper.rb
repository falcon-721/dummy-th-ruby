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
end
