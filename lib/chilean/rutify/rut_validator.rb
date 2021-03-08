##
# Validates that the given string has the correct rut syntax

class RutValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || !value.is_a?(String)
      record.errors.add attribute, (options[:message] || "is a empty rut")
    elsif !Chilean::Rutify.valid_rut?(value)
      record.errors.add attribute, (options[:message] || "is not a valid rut")
    end
  end
end
