class MoveDestinationFileToTask < ActiveRecord::Migration[5.0]
  def up
    remove_column :data_transfers, :destination_file_id
    drop_table :destination_files
  end

  def down
    create_table :destination_files, id: :uuid do |t|
      t.string :name, null: false
      t.integer :position
      t.string :path
      t.uuid :task_id

      t.timestamps null: false
    end

    add_column :data_transfers, :destination_file_id, :uuid
  end
end
