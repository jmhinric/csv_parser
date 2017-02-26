# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.transaction do
  user = User.create!(email: "john@evergreen.com", password: "password", password_confirmation: "password")

  # Example 1
  # Cost Analysis
  template = Template.create!(
    name: "Cost Analysis Report",
    description: "Example 1: Cost analysis report based on Enrollment and Claims forms",
    user: user
  )

  enrollment = OriginFile.create!(name: "Enrollment", position: 0, template: template)
  claims = OriginFile.create!(name: "Claims", position: 1, template: template)

  dtg1 = DataTransferGroup.create!(from_type: :column, to_type: :column, origin_file: enrollment)
  (12..23).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg1,
      origin_worksheet_index: 0,
      destination_worksheet_index: 3,
      origin_row: row,
      origin_col: 2,
      destination_row: row + 1,
      destination_col: 7
    )

    DataTransfer.create!(
      data_transfer_group: dtg1,
      origin_worksheet_index: 0,
      destination_worksheet_index: 4,
      origin_row: row,
      origin_col: 8,
      destination_row: row + 1,
      destination_col: 7
    )

    DataTransfer.create!(
      data_transfer_group: dtg1,
      origin_worksheet_index: 0,
      destination_worksheet_index: 5,
      origin_row: row,
      origin_col: 4,
      destination_row: row + 1,
      destination_col: 7
    )
  end

  # Medical
  dtg2 = DataTransferGroup.create!(from_type: :column, to_type: :column, origin_file: claims)
  (11..22).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg2,
      origin_worksheet_index: 0,
      destination_worksheet_index: 3,
      origin_row: row,
      origin_col: 2,
      destination_row: row + 2,
      destination_col: 27
    )
  end

  (25..36).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg2,
      origin_worksheet_index: 0,
      destination_worksheet_index: 5,
      origin_row: row,
      origin_col: 2,
      destination_row: row - 12,
      destination_col: 27
    )
  end

  (48..59).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg2,
      origin_worksheet_index: 0,
      destination_worksheet_index: 4,
      origin_row: row,
      origin_col: 2,
      destination_row: row - 35,
      destination_col: 27
    )
  end

  # Rx
  dtg3 = DataTransferGroup.create!(from_type: :column, to_type: :column, origin_file: claims)
  (11..22).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg3,
      origin_worksheet_index: 0,
      destination_worksheet_index: 3,
      origin_row: row,
      origin_col: 3,
      destination_row: row + 2,
      destination_col: 29
    )
  end

  (25..36).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg3,
      origin_worksheet_index: 0,
      destination_worksheet_index: 5,
      origin_row: row,
      origin_col: 3,
      destination_row: row - 12,
      destination_col: 29
    )
  end

  (48..59).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg3,
      origin_worksheet_index: 0,
      destination_worksheet_index: 4,
      origin_row: row,
      origin_col: 3,
      destination_row: row - 35,
      destination_col: 29
    )
  end


  # Example 2
  template2 = Template.create!(
    name: "Example 2",
    description: "Example 2: Simple case of copying from two origin files to one destination file",
    user: user
  )

  origin1 = OriginFile.create!(name: "Origin 1", position: 0, template: template2)
  origin2 = OriginFile.create!(name: "Origin 2", position: 1, template: template2)

  dtg4 = DataTransferGroup.create!(from_type: :row, to_type: :column, origin_file: origin1)
  (3..5).each do |col|
    DataTransfer.create!(
      data_transfer_group: dtg4,
      origin_worksheet_index: 0,
      destination_worksheet_index: 0,
      origin_row: 10,
      origin_col: col,
      destination_row: col - 1,
      destination_col: 1
    )
  end

  dtg5 = DataTransferGroup.create!(from_type: :row, to_type: :column, origin_file: origin2)
  (7..9).each do |row|
    DataTransfer.create!(
      data_transfer_group: dtg5,
      origin_worksheet_index: 0,
      destination_worksheet_index: 0,
      origin_row: row,
      origin_col: 1,
      destination_row: row - 5,
      destination_col: 2
    )
  end


  dtg6 = DataTransferGroup.create!(from_type: :single, to_type: :single, origin_file: origin2)
  DataTransfer.create!(
    data_transfer_group: dtg6,
    origin_worksheet_index: 0,
    destination_worksheet_index: 0,
    origin_row: 12,
    origin_col: 3,
    destination_row: 5,
    destination_col: 4
  )
end
