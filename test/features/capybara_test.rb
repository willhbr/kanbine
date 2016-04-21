require File.expand_path('../../test_helper', __FILE__)

describe "the home page", type: :feature do
  it "should say 'Redmine'" do
    visit '/'
    expect(page).to have_content 'Redmine'
  end
end
