# frozen_string_literal: true

require_relative "rutify/version"
require_relative "rutify/rut_validator"
require_relative "rutify/errors"
require_relative "rutify/rutifiable"

module Chilean
  # Chilean rut utils module
  module Rutify
    # checks if the passed value is valid as a rut character
    def valid_rut_value?(rv)
      ['0','1','2','3','4','5','6','7','8','9','k','K','.','-'].include?(rv)
    end

    # returns the rut verifier value
    def get_verifier(rut)
      sum = 0
      mul = 2

      rut.to_s.reverse.split("").each do |i|
        sum += i.to_i * mul
        mul = mul == 7 ? 2 : mul + 1
      end

      res = sum % 11

      case res
      when 1
        "K"
      when 0
        "0"
      else
        (11 - res).to_s
      end
    end

    # checks if the passed rut has a proper verifier value
    def valid_rut_verifier?(raw_rut)
      rut = normalize_rut(raw_rut)
      return false if rut.empty? || rut.size < 2 || !rut.is_a?(String)

      r = rut[0..(rut.size - 2)]
      get_verifier(r) == rut[-1]
    end

    # returns the rut value without any sepecial caracter and upcased
    def normalize_rut(rut)
      return if rut.nil? || !rut.is_a?(String) || !valid_rut_values?(rut)

      rut = rut.delete "."
      rut = rut.delete "-"
      rut.upcase
    end

    # returns the rut value with the chilean format
    def format_rut(raw_rut)
      rut = normalize_rut(raw_rut)
      return if rut.nil? || rut.empty? || rut.size < 2

      verifier = rut[-1]
      temp_rut = rut[0..-2]
      init_rut = ""

      while temp_rut.length > 3
        init_rut = "." + temp_rut[(temp_rut.size - 3)..temp_rut.size] + init_rut
        temp_rut = temp_rut[0..-4]
      end

      rut = temp_rut + init_rut + "-" + verifier
      rut.upcase
    end

    # checks if the passed rut is valid
    def valid_rut?(raw_rut)
      rut = normalize_rut(raw_rut)
      return false if rut.nil? || rut.empty? || rut.size < 2
      return false unless valid_rut_values?(rut)

      valid_rut_verifier?(rut)
    end

    def valid_rut_values?(raw_rut)
      raw_rut.split("").each do |i|
        return false unless valid_rut_value?(i)
      end
    end

    module_function :normalize_rut, :format_rut, :valid_rut_value?, :get_verifier, :valid_rut?, :valid_rut_verifier?,
                    :valid_rut_values?
  end
end
