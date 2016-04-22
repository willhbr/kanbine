require File.expand_path('../../test_helper', __FILE__)

describe "issues in the kanban board", type: :feature do
  before :all do
    core_fixtures :all
    @project = Project.first
    init_kanbine @project
  end

  before :each do
    @user = User.first
    login_as @user.login, 'admin'
  end

  it 'can be dragged from one status to another' do
    visit "/projects/#{@project.identifier}/kanban"
    move_issue = Issue.find_by_subject 'Cannot print recipes'
    status = IssueStatus.find_by_name 'Assigned'
    find("#kb-row-#{move_issue.id}").drag_to find("#kb-col-#{status.id} .sortable")
    wait_for_ajax
    expect(find("#kb-col-#{status.id}")).to have_content 'Cannot print recipes'
  end
end
