# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.transaction do
  user = User.create!(email: "bruce@wayne.com", password: "batman", password_confirmation: "batman")

  # Cost Analysis
  task = Task.create!(
    name: "Cost Analysis Report",
    description: "Cost analysis report based on Enrollment and Claims forms",
    user: user
  )

  enrollment = OriginFile.create!(name: "Enrollment", position: 0, task: task)
  claims = OriginFile.create!(name: "Claims", position: 1, task: task)

  result_file = DestinationFile.create!(
    name: "Cost Analysis Template File",
    path: "cost_analysis.xlsx",
    task: task
  )

  (12..23).each do |row|
    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 3,
      origin_file: enrollment,
      destination_file: result_file,
      origin_row: row,
      origin_col: 2,
      destination_row: row + 1,
      destination_col: 7
    )

    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 4,
      origin_file: enrollment,
      destination_file: result_file,
      origin_row: row,
      origin_col: 8,
      destination_row: row + 1,
      destination_col: 7
    )

    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 5,
      origin_file: enrollment,
      destination_file: result_file,
      origin_row: row,
      origin_col: 4,
      destination_row: row + 1,
      destination_col: 7
    )
  end

  # Medical
  (11..22).each do |row|
    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 3,
      origin_file: claims,
      destination_file: result_file,
      origin_row: row,
      origin_col: 2,
      destination_row: row + 2,
      destination_col: 27
    )
  end

  (25..36).each do |row|
    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 5,
      origin_file: claims,
      destination_file: result_file,
      origin_row: row,
      origin_col: 2,
      destination_row: row - 12,
      destination_col: 27
    )
  end

  (48..59).each do |row|
    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 4,
      origin_file: claims,
      destination_file: result_file,
      origin_row: row,
      origin_col: 2,
      destination_row: row - 35,
      destination_col: 27
    )
  end

  # Rx
  (11..22).each do |row|
    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 3,
      origin_file: claims,
      destination_file: result_file,
      origin_row: row,
      origin_col: 3,
      destination_row: row + 2,
      destination_col: 29
    )
  end

  (25..36).each do |row|
    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 5,
      origin_file: claims,
      destination_file: result_file,
      origin_row: row,
      origin_col: 3,
      destination_row: row - 12,
      destination_col: 29
    )
  end

  (48..59).each do |row|
    DataTransfer.create!(
      origin_worksheet_index: 0,
      destination_worksheet_index: 4,
      origin_file: claims,
      destination_file: result_file,
      origin_row: row,
      origin_col: 3,
      destination_row: row - 35,
      destination_col: 29
    )
  end
end
