# frozen_string_literal: true

module Chilean
  # Handles rut validation and formating on models (asumes rut column on model)
  #
  # Options:
  #
  # - :rut_format - The rut setter format, can be [:classic, :normalized, :dash_only, :nil], defaults to `:classic`.
  module Rutifiable
    # TODO: Make Rspec tests
    extend ActiveSupport::Concern

    included do
      class_attribute :rut_format
      self.rut_format = :classic

      # Validations
      validates :rut, presence: true, uniqueness: { case_sensitive: false }, rut: true
    end

    # Override rails setter for rut column
    def rut=(value)
      value = Chilean::Rutify.classic_rut(value) if rut_format == :classic
      value = Chilean::Rutify.normalize_rut(value) if rut_format == :normalized
      value = Chilean::Rutify.dash_only_rut(value) if rut_format == :dash_only
      super
    end
  end
end
