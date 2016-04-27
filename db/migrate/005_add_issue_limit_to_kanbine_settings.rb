class AddIssueLimitToKanbineSettings < ActiveRecord::Migration
  def change
    add_column :kanbine_settings, :issue_limit, :integer, default: 15
  end
end
