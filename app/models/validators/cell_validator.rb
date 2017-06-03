module Validators
  class CellValidator < ActiveModel::EachValidator
    VALID_CELL_REGEX = /^[A-Za-z]+[0-9]+$/

    def validate_each(record, attribute, value)
      record.errors[attribute] << 'Invalid cell' unless value =~ VALID_CELL_REGEX
    end
  end
end
