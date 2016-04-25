class CreateProjectKanbanTrackers < ActiveRecord::Migration
  def change
    create_join_table :projects, :trackers, {
      table_name: :project_kanban_trackers
    }
  end
end
