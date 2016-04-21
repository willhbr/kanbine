class CreateKanbineSettings < ActiveRecord::Migration
  def change
    create_table :kanbine_settings do |t|
      t.integer :project_id
      # I'll add something here later.
    end
  end
end
