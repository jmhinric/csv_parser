module Validators
  class EmailValidator < ActiveModel::EachValidator
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    def validate_each(record, attribute, value)
      record.errors[attribute] << error_message unless value =~ VALID_EMAIL_REGEX
    end

    def error_message
      "Email is invalid"
    end
  end
end
