class CreateProjectKanbanStatuses < ActiveRecord::Migration
  def change
    create_join_table :projects, :issue_statuses, {
      table_name: :project_kanban_statuses
    }
  end
end
