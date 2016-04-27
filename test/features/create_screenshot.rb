require File.expand_path('../../test_helper', __FILE__)

describe "the kanbine plugin", type: :feature do
  before :all do
    core_fixtures :all
    @project = Project.first
    init_kanbine @project
    Setting.ui_theme = 'catalyst'
  end

  before :each do
    @user = User.first
    login_as @user.login, 'admin'
  end

  it 'can be screenshotted' do
    visit "/projects/#{@project.identifier}/kanban"

    page.save_screenshot '/vagrant/plugins/kanbine/screenshot.png', full: true
  end
end
