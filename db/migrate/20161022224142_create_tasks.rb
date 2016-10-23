class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.uuid :user_id

      t.timestamps null: false
    end

    create_table :origin_files, id: :uuid do |t|
      t.string :name, null: false
      t.integer :position
      t.uuid :task_id

      t.timestamps null: false
    end

    create_table :destination_files, id: :uuid do |t|
      t.string :name, null: false
      t.integer :position
      t.string :path
      t.uuid :task_id

      t.timestamps null: false
    end

    create_table :data_transfers, id: :uuid do |t|
      t.integer :origin_row, null: false
      t.integer :origin_col, null: false
      t.integer :destination_row, null: false
      t.integer :destination_col, null: false
      t.integer :origin_worksheet_index, null: false, default: 0
      t.integer :destination_worksheet_index, null: false
      t.uuid :origin_file_id
      t.uuid :destination_file_id

      t.timestamps null: false
    end

    add_foreign_key :tasks, :users
    add_foreign_key :origin_files, :tasks
    add_foreign_key :data_transfers, :origin_files
    add_foreign_key :data_transfers, :destination_files
    add_foreign_key :destination_files, :tasks

    add_index(:origin_files, :position, unique: true)
    add_index(:destination_files, :position, unique: true)
  end
end
