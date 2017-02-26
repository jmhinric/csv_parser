class RenameTaskToTemplate < ActiveRecord::Migration[5.0]
  def up
    remove_index :origin_files, [:position, :task_id]
    rename_table :tasks, :templates
    rename_column :origin_files, :task_id, :template_id
    add_index :origin_files, [:position, :template_id], unique: true
  end

  def down
    remove_index :origin_files, :template_id
    rename_table :templates, :tasks
    rename_column :origin_files, :template_id, :task_id
    add_index :origin_files, :task_id
  end
end
