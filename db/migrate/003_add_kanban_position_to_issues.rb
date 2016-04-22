class AddKanbanPositionToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :kanban_position, :integer
  end
end
