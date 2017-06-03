# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.transaction do
  user = User.create!(email: "john@evergreen.com", password: "password", password_confirmation: "password")

  ##################################################################################################
  ##################################################################################################
  # Cost Analysis
  ##################################################################################################
  ##################################################################################################

  template = Template.create!(
    name: "Cost Analysis Report",
    description: "Example 1: Cost analysis report based on Enrollment and Claims forms",
    user: user
  )

  enrollment = OriginFile.create!(name: "Enrollment", position: 0, template: template)
  claims = OriginFile.create!(name: "Claims", position: 1, template: template)

  # Enrollment
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'C13', end_value: 'C24')
  destination = DestinationCellRange.create!(worksheet_index: 3, begin_value: 'H14', end_value: 'H25')
  RangeDataTransfer.create!(origin_file: enrollment, origin_cell_range: origin, destination_cell_range: destination)

  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'I13', end_value: 'I24')
  destination = DestinationCellRange.create!(worksheet_index: 4, begin_value: 'H14', end_value: 'H25')
  RangeDataTransfer.create!(origin_file: enrollment, origin_cell_range: origin, destination_cell_range: destination)

  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'E13', end_value: 'E24')
  destination = DestinationCellRange.create!(worksheet_index: 5, begin_value: 'H14', end_value: 'H25')
  RangeDataTransfer.create!(origin_file: enrollment, origin_cell_range: origin, destination_cell_range: destination)


  # Medical
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'C12', end_value: 'C23')
  destination = DestinationCellRange.create!(worksheet_index: 3, begin_value: 'AB14', end_value: 'AB25')
  RangeDataTransfer.create!(origin_file: claims, origin_cell_range: origin, destination_cell_range: destination)

  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'C49', end_value: 'C60')
  destination = DestinationCellRange.create!(worksheet_index: 4, begin_value: 'AB14', end_value: 'AB25')
  RangeDataTransfer.create!(origin_file: claims, origin_cell_range: origin, destination_cell_range: destination)

  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'C26', end_value: 'C37')
  destination = DestinationCellRange.create!(worksheet_index: 5, begin_value: 'AB14', end_value: 'AB25')
  RangeDataTransfer.create!(origin_file: claims, origin_cell_range: origin, destination_cell_range: destination)


  # Rx
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'D12', end_value: 'D23')
  destination = DestinationCellRange.create!(worksheet_index: 3, begin_value: 'AD14', end_value: 'AD25')
  RangeDataTransfer.create!(origin_file: claims, origin_cell_range: origin, destination_cell_range: destination)

  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'D49', end_value: 'D60')
  destination = DestinationCellRange.create!(worksheet_index: 4, begin_value: 'AD14', end_value: 'AD25')
  RangeDataTransfer.create!(origin_file: claims, origin_cell_range: origin, destination_cell_range: destination)

  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'D26', end_value: 'D37')
  destination = DestinationCellRange.create!(worksheet_index: 5, begin_value: 'AD14', end_value: 'AD25')
  RangeDataTransfer.create!(origin_file: claims, origin_cell_range: origin, destination_cell_range: destination)



  ##################################################################################################
  ##################################################################################################
  # Example 2
  ##################################################################################################
  ##################################################################################################

  template2 = Template.create!(
    name: "Simple Example",
    description: "Example 2: Simple case of copying from one origin file to one destination file",
    user: user
  )

  origin1 = OriginFile.create!(name: "Origin 1", position: 0, template: template2)

  # Single
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'A1')
  destination = DestinationCellRange.create!(worksheet_index: 0, begin_value: 'D1')
  SingleDataTransfer.create!(origin_file: origin1, origin_cell_range: origin, destination_cell_range: destination)

  # Column to column
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'B1', end_value: 'B3')
  destination = DestinationCellRange.create!(worksheet_index: 0, begin_value: 'C2', end_value: 'C4')
  RangeDataTransfer.create!(origin_file: origin1, origin_cell_range: origin, destination_cell_range: destination)

  # Row to row
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'D5', end_value: 'G5')
  destination = DestinationCellRange.create!(worksheet_index: 1, begin_value: 'B2', end_value: 'E2')
  RangeDataTransfer.create!(origin_file: origin1, origin_cell_range: origin, destination_cell_range: destination)

  # Row to column
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'D6', end_value: 'G6')
  destination = DestinationCellRange.create!(worksheet_index: 1, begin_value: 'A14', end_value: 'A17')
  RangeDataTransfer.create!(origin_file: origin1, origin_cell_range: origin, destination_cell_range: destination)

  # Column to row
  origin = OriginCellRange.create!(worksheet_index: 0, begin_value: 'B5', end_value: 'B7')
  destination = DestinationCellRange.create!(worksheet_index: 1, begin_value: 'C3', end_value: 'E3')
  RangeDataTransfer.create!(origin_file: origin1, origin_cell_range: origin, destination_cell_range: destination)
end
