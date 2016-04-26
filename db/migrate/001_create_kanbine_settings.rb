class CreateKanbineSettings < ActiveRecord::Migration
  def change
    create_table :kanbine_settings do |t|
      t.integer :project_id
      t.integer :color_tag_group_id
    end
  end
end
