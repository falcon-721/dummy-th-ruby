require 'acceptance_helper'

xfeature 'subdomains', :js do
  scenario "visit subdomains", :visual do
    visit questions_path
    expect(page).to match_reference_screenshot label: 'default'

    switch_subdomain('green')
    visit questions_path
    expect(page).to match_reference_screenshot label: 'green'
  end
end
