# == Schema Information
#
# Table name: cell_ranges
#
#  id               :uuid             not null, primary key
#  type             :string
#  begin_value      :string
#  end_value        :string
#  worksheet_index  :integer
#  data_transfer_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CellRange < ApplicationRecord
  belongs_to :data_transfer, foreign_key: 'data_transfer_id'
  belongs_to :single_data_transfer, foreign_key: 'data_transfer_id', class_name: 'SingleDataTransfer'
  belongs_to :range_data_transfer, foreign_key: 'data_transfer_id', class_name: 'RangeDataTransfer'

  validates_with Validators::CellValidator, attributes: [:begin_value]
  validate :valid_end_value

  def cells
    unless end_value
      return [{
        cell_col_name => begin_letter_index,
        cell_row_name => begin_number_index,
        cell_worksheet_index_name => worksheet_index
      }]
    end

    # Is a column
    if begin_letter_index == end_letter_index
      (begin_number_index..end_number_index).map do |n|
        {
          cell_col_name => begin_letter_index,
          cell_row_name => n,
          cell_worksheet_index_name => worksheet_index
        }
      end
    else # Is a row
      (begin_letter_index..end_letter_index).map do |n|
        {
          cell_col_name => n,
          cell_row_name => begin_number_index,
          cell_worksheet_index_name => worksheet_index
        }
      end
    end
  end

  private

  def letters_cipher
    letters = ('A'..'Z').to_a
    @letters_cipher ||= (
      letters +
      letters.map do |first_letter|
        letters.map { |last_letter| first_letter + last_letter }
      end
    ).flatten
  end

  def begin_letter_index
    letters_cipher.index(letter_value(begin_value))
  end

  def end_letter_index
    letters_cipher.index(letter_value(end_value))
  end

  def letter_value(value)
    value[/[a-zA-Z]+/]
  end

  def begin_number_index
    number_value(begin_value).to_i - 1
  end

  def end_number_index
    number_value(end_value).to_i - 1
  end

  def number_value(value)
    value[/[0-9]+/]
  end

  def valid_end_value
    return unless data_transfer.is_a?(RangeDataTransfer)
    validates_with Validators::CellValidator, attributes: [:end_value]
  end

  %i(cell_col_name cell_row_name cell_worksheet_index_name).each do |method|
    define_method(method) { raise NoMethodError }
  end
end
