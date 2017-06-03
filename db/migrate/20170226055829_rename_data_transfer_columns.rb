class RenameDataTransferColumns < ActiveRecord::Migration[5.0]
  def up
    add_column :data_transfers, :type, :string

    remove_column :data_transfers, :origin_row
    remove_column :data_transfers, :origin_col
    remove_column :data_transfers, :origin_worksheet_index
    remove_column :data_transfers, :destination_row
    remove_column :data_transfers, :destination_col
    remove_column :data_transfers, :destination_worksheet_index

    create_table :cell_ranges, id: :uuid do |t|
      t.string :type
      t.string :begin_value
      t.string :end_value
      t.integer :worksheet_index
      t.uuid :data_transfer_id

      t.timestamps null:false
    end
    add_index :cell_ranges, :data_transfer_id
  end

  def down
    remove_column :data_transfers, :type

    add_column :data_transfers, :origin_row, :integer
    add_column :data_transfers, :origin_col, :integer
    add_column :data_transfers, :origin_worksheet_index, :integer
    add_column :data_transfers, :destination_row, :integer
    add_column :data_transfers, :destination_col, :integer
    add_column :data_transfers, :destination_worksheet_index, :integer

    drop_table :cell_ranges
  end
end
