# frozen_string_literal: true

# Validates that the given string has the correct rut syntax
class RutValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if Chilean::Rutify.valid_rut?(value)

    record.errors.add attribute, (options[:message] || "is not a valid rut")
  end
end
