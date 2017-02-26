class CreateDataTransferGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :data_transfer_groups, id: :uuid do |t|
      t.integer :from_type
      t.integer :to_type
      t.uuid :origin_file_id

      t.timestamps null: false
    end

    rename_column :data_transfers, :origin_file_id, :data_transfer_group_id

    remove_foreign_key :data_transfers, :origin_files
    add_foreign_key :data_transfers, :data_transfer_groups
    add_foreign_key :data_transfer_groups, :origin_files
    add_index :data_transfer_groups, :origin_file_id
  end
end
