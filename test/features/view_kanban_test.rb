require File.expand_path('../../test_helper', __FILE__)

describe "the kanban board", type: :feature do
  before :all do
    core_fixtures :all
    @project = Project.first
    init_kanbine @project
  end

  before :each do
    @user = User.first
    login_as @user.login, 'admin'
  end

  it 'should be in the main menu' do
    visit '/projects/' + @project.identifier
    expect(find('a.kanbine-kanban')).to have_content 'Kanban'
  end

  it "should be visible" do
    visit "/projects/#{@project.identifier}/kanban"
    ['New', 'Assigned', 'Closed'].each do |status|
      expect(page).to have_content status
    end
  end
end
