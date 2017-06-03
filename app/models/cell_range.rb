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

  validates_with Validators::CellValidator, attributes: [:begin_value, :end_value]
  validates :begin_value, presence: :true
  validates :end_value, presence: :true, if: -> { range_data_transfer }
  validate :is_a_row_or_column, if: -> { range_data_transfer }

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

  def length
    return unless begin_value && end_value
    return 1 if !begin_value || !end_value

    return (end_letter_index - begin_letter_index).abs + 1 if row?
    (end_number_index - begin_number_index).abs + 1
  end

  private

  %i(cell_col_name cell_row_name cell_worksheet_index_name).each do |method|
    define_method(method) { raise NoMethodError }
  end

  def letters_cipher
    letters = ('A'..'Z').to_a
    @letters_cipher ||= (
      letters +
      letters.map do |first_letter|
        letters.map { |last_letter| first_letter + last_letter }
      end
    ).flatten
  end

  def begin_letter
    letter_value(begin_value)
  end

  def end_letter
    letter_value(end_value)
  end

  def begin_number
    number_value(begin_value)
  end

  def end_number
    number_value(end_value)
  end

  def begin_letter_index
    letters_cipher.index(begin_letter)
  end

  def end_letter_index
    letters_cipher.index(end_letter)
  end

  def begin_number_index
    begin_number.to_i - 1
  end

  def end_number_index
    end_number.to_i - 1
  end

  def letter_value(value)
    value[/[a-zA-Z]+/]
  end

  def number_value(value)
    value[/[0-9]+/]
  end

  def row?
    begin_number == end_number
  end

  def column?
    begin_letter == end_letter
  end

  def is_a_row_or_column
    return unless begin_value && end_value

    if (begin_letter != end_letter && begin_number != end_number)
      errors.add(:end_value, 'does not make a row or column')
    end
  end
end
