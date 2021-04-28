# frozen_string_literal: true

RSpec.describe Chilean::Rutify do
  it "has a version number" do
    expect(Chilean::Rutify::VERSION).not_to be nil
  end

  describe "valid_rut_value?" do
    it { expect(described_class.valid_rut_value?("y")).to eq false }
    it { expect(described_class.valid_rut_value?("/")).to eq false }
    it { expect(described_class.valid_rut_value?([])).to eq false }
    it { expect(described_class.valid_rut_value?(0)).to eq true }
    it { expect(described_class.valid_rut_value?("9")).to eq true }
    it { expect(described_class.valid_rut_value?("k")).to eq true }
    it { expect(described_class.valid_rut_value?("K")).to eq true }
  end

  describe "valid_rut_values?" do
    it { expect(described_class.valid_rut_values?("ya12")).to eq false }
    it { expect(described_class.valid_rut_values?("/s21")).to eq false }
    it { expect(described_class.valid_rut_values?(["1234"])).to eq false }
    it { expect(described_class.valid_rut_values?(1230)).to eq true }
    it { expect(described_class.valid_rut_values?("4.678-9")).to eq true }
    it { expect(described_class.valid_rut_values?("234k")).to eq true }
    it { expect(described_class.valid_rut_values?("K")).to eq true }
  end

  describe "get_verifier" do
    it { expect(described_class.get_verifier("12148514")).to eq "1" }
    it { expect(described_class.get_verifier("23379716")).to eq "2" }
    it { expect(described_class.get_verifier("32938250")).to eq "8" }
    it { expect(described_class.get_verifier("36128619")).not_to eq "0" }
    it { expect(described_class.get_verifier("36228719")).not_to eq "0" }
    it { expect(described_class.get_verifier("36238719")).not_to eq "0" }
  end

  describe "valid_rut_verifier?" do
    it { expect(described_class.valid_rut_verifier?("12.148.514-1")).to eq true }
    it { expect(described_class.valid_rut_verifier?("23.379.716-2")).to eq true }
    it { expect(described_class.valid_rut_verifier?("18.486.758-3")).to eq true }
    it { expect(described_class.valid_rut_verifier?("14.001.723-8")).to eq false }
    it { expect(described_class.valid_rut_verifier?("14.175.644-4")).to eq false }
  end

  describe "normalize_rut" do
    it { expect(described_class.normalize_rut("12.148.514-1")).to eq "121485141" }
    it { expect(described_class.normalize_rut("12.514-1")).to eq "125141" }
  end

  describe "format_rut" do
    it { expect(described_class.format_rut("121485141")).to eq "12.148.514-1" }
    it { expect(described_class.format_rut("125141")).to eq "12.514-1" }
  end

  describe "valid_rut?" do
    it { expect(described_class.valid_rut?("12.148.514-1")).to eq true }
    it { expect(described_class.valid_rut?("23.379.716-2")).to eq true }
    it { expect(described_class.valid_rut?("18.486.758-3")).to eq true }
    it { expect(described_class.valid_rut?("14.001.723-8")).to eq false }
    it { expect(described_class.valid_rut?("14.175.644-4")).to eq false }
  end

  describe "stringify_rut" do
    it { expect(described_class.stringify_rut("12.148.514-1")).to eq "12.148.514-1" }
    it { expect(described_class.stringify_rut(121485141)).to eq "121485141" }
    it { expect(described_class.stringify_rut([])).to eq nil }
    it { expect(described_class.stringify_rut(["1234"])).to eq nil }
  end
end
