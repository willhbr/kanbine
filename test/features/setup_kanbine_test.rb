require File.expand_path('../../test_helper', __FILE__)

describe "the kanbine plugin", type: :feature do
  before :all do
    core_fixtures :all
    @project = Project.first
  end

  before :each do
    @user = User.first
    login_as @user.login, 'admin'
  end

  it 'can be setup for a project' do
    visit "/projects/#{@project.identifier}"
    click_on 'Settings'
    click_on 'Modules'
    check 'Kanbine'
    click_on 'Save'
    click_on 'Kanbine'
    check_all 'New', 'Assigned', 'Closed'
    check_all 'Bug', 'Feature request'
    uncheck 'Support request'
    click_on 'Save'
    @project.module_enabled?('kanbine').should be_true
    @project.kanban_statuses.map(&:name).sort.should == ['Assigned', 'Closed', 'New']
    @project.kanban_trackers.map(&:name).sort.should == ['Bug', 'Feature request']
  end
end
