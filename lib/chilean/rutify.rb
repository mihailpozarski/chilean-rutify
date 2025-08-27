# frozen_string_literal: true

require_relative "rutify/version"
require_relative "rutify/rut_validator"
require_relative "rutify/errors"
require_relative "rutify/rutifiable"

module Chilean
  # Chilean rut utils module
  module Rutify
    # checks if the passed value is valid as a rut character
    def valid_rut_value?(value, allow_k: false)
      base_values = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "-"]
      base_values.push("K", "k") if allow_k

      base_values.include?(value.to_s)
    end

    # returns the rut verifier value
    def get_verifier(raw_rut)
      rut = stringify_rut(raw_rut)
      return unless rut.present? && valid_rut_values?(rut)

      sum = 0
      mul = 2

      rut.reverse.chars.each do |i|
        sum += i.to_i * mul
        mul = mul == 7 ? 2 : mul + 1
      end

      res = sum % 11

      translate_verifier_result(res)
    end

    # translate the result of the rut calculations
    def translate_verifier_result(result)
      case result
      when 1
        "K"
      when 0
        "0"
      else
        (11 - result).to_s
      end
    end

    # checks if the passed rut has a proper verifier value
    def valid_rut_verifier?(raw_rut)
      rut = normalize_rut(raw_rut)
      return false unless rut.present? && valid_rut_values?(rut)

      r = rut[0..(rut.size - 2)]
      get_verifier(r) == rut[-1]
    end

    # returns the rut value without any sepecial caracter and upcased
    def normalize_rut(raw_rut)
      rut = stringify_rut(raw_rut)
      return unless rut.present? && valid_rut_values?(rut)

      rut = rut.delete "."
      rut = rut.delete "-"
      rut.upcase
    end

    # returns the rut value with only the dash
    def dash_only_rut(raw_rut)
      rut = normalize_rut(raw_rut)
      return unless rut.present? && valid_rut_values?(rut)

      "#{rut[0..-2]}-#{rut[-1]}"
    end

    # returns the rut value with the chilean format
    def classic_rut(raw_rut)
      rut = normalize_rut(raw_rut)
      return unless rut.present? && valid_rut_values?(rut)

      verifier = rut[-1]
      temp_rut = rut[0..-2]
      init_rut = ""

      while temp_rut.length > 3
        init_rut = ".#{temp_rut[(temp_rut.size - 3)..temp_rut.size]}#{init_rut}"
        temp_rut = temp_rut[0..-4]
      end

      "#{temp_rut}#{init_rut}-#{verifier}".upcase
    end

    # returns the rut value with the specified format (default is classic )
    def format_rut(raw_rut, format = :classic)
      rut = stringify_rut(raw_rut)
      return unless rut.present? && valid_rut_values?(rut)

      case format
      when :normalized
        normalize_rut(rut)
      when :dash_only
        dash_only_rut(rut)
      when :classic
        classic_rut(rut)
      end
    end

    # checks if the passed rut is valid
    def valid_rut?(raw_rut)
      rut = normalize_rut(raw_rut)
      return false unless rut.present? && valid_rut_values?(rut)

      valid_rut_verifier?(rut)
    end

    # checks if all the rut values are valid
    def valid_rut_values?(raw_rut)
      rut = stringify_rut(raw_rut)
      return false unless rut.present?

      rut.chars.each_with_index do |c, i|
        return false unless valid_rut_value?(c, allow_k: i == rut.length - 1)
      end

      true
    end

    # checks rut minimum requirements and transform value to string if posible
    def stringify_rut(raw_rut)
      return if raw_rut.nil? || (!raw_rut.is_a?(String) && !raw_rut.is_a?(Integer))

      raw_rut.to_s
    end

    module_function :normalize_rut, :format_rut, :valid_rut_value?, :get_verifier, :valid_rut?, :valid_rut_verifier?,
                    :valid_rut_values?, :stringify_rut, :translate_verifier_result, :dash_only_rut, :classic_rut
  end
end
