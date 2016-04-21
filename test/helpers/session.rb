# helpers for login, logout etc

module Helpers
  def login_as(username, password)
    visit '/login'
    within '#login-form' do
      fill_in 'username', with: username
      fill_in 'password', with: password
    end
    click_on 'Login'
    expect(page).to have_content "Logged in as #{username}"
  end
end
