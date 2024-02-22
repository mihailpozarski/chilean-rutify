# frozen_string_literal: true

RSpec.describe Chilean::Rutify do
  it "has a version number" do
    expect(Chilean::Rutify::VERSION).not_to be nil
  end

  describe "valid_rut_value?" do
    context "when given a invalid values" do
      it "returns false" do
        expect(described_class.valid_rut_value?("y")).to eq false
        expect(described_class.valid_rut_value?("/")).to eq false
        expect(described_class.valid_rut_value?([])).to eq false
      end
    end
    context "when given a valid values" do
      it "returns true" do
        expect(described_class.valid_rut_value?(0)).to eq true
        expect(described_class.valid_rut_value?("9")).to eq true
        expect(described_class.valid_rut_value?("k")).to eq true
        expect(described_class.valid_rut_value?("K")).to eq true
      end
    end
  end

  describe "valid_rut_values?" do
    context "when given a invalid values" do
      it "returns false" do
        expect(described_class.valid_rut_values?("ya12")).to eq false
        expect(described_class.valid_rut_values?("/s21")).to eq false
        expect(described_class.valid_rut_values?(["1234"])).to eq false
      end
    end
    context "when given a valid values" do
      it "returns true" do
        expect(described_class.valid_rut_values?("1234")).to eq true
        expect(described_class.valid_rut_values?(1_230)).to eq true
        expect(described_class.valid_rut_values?("4.678-9")).to eq true
        expect(described_class.valid_rut_values?("234k")).to eq true
        expect(described_class.valid_rut_values?("K")).to eq true
      end
    end
  end

  describe "get_verifier" do
    it "returns the correct verifier" do
      expect(described_class.get_verifier("12148514")).to eq "1"
      expect(described_class.get_verifier("23379716")).to eq "2"
      expect(described_class.get_verifier("32938250")).to eq "8"
      expect(described_class.get_verifier("36128619")).not_to eq "0"
      expect(described_class.get_verifier("36228719")).not_to eq "0"
      expect(described_class.get_verifier("36238719")).not_to eq "0"
    end
  end

  describe "valid_rut_verifier?" do
    context "when given a valid rut" do
      it "returns true" do
        expect(described_class.valid_rut_verifier?("12.148.514-1")).to eq true
        expect(described_class.valid_rut_verifier?("23.379.716-2")).to eq true
        expect(described_class.valid_rut_verifier?("18.486.758-3")).to eq true
      end
    end
    context "when given a invalid rut" do
      it "returns false" do
        expect(described_class.valid_rut_verifier?("14.001.723-8")).to eq false
        expect(described_class.valid_rut_verifier?("14.175.644-4")).to eq false
      end
    end
  end

  describe "normalize_rut" do
    it "removes dots and dash" do
      expect(described_class.normalize_rut("12.148.514-1")).to eq "121485141"
      expect(described_class.normalize_rut("12.514-1")).to eq "125141"
      expect(described_class.normalize_rut("128.538-9")).to eq "1285389"
    end
  end

  describe "classic_rut" do
    it "normalizes RUT with dots and dash" do
      expect(described_class.classic_rut("12.148.514-1")).to eq "12.148.514-1"
      expect(described_class.classic_rut("125141")).to eq "12.514-1"
      expect(described_class.classic_rut("1285389")).to eq "128.538-9"
    end
  end

  describe "dash_only_rut" do
    it "returns the rut value with only the dash" do
      expect(described_class.dash_only_rut("12.148.514-1")).to eq "12148514-1"
      expect(described_class.dash_only_rut("125141")).to eq "12514-1"
      expect(described_class.dash_only_rut("1285389")).to eq "128538-9"
    end
  end

  describe "format_rut" do
    context "when no format is given" do
      it "returns the rut value with the classic chilean format" do
        expect(described_class.format_rut("1285389")).to eq "128.538-9"
        expect(described_class.format_rut("121485141")).to eq "12.148.514-1"
        expect(described_class.format_rut("125141")).to eq "12.514-1"
      end
    end
    context "when dash_only format is given" do
      it "returns the rut value with only the dash" do
        expect(described_class.format_rut("1285389", :dash_only)).to eq "128538-9"
        expect(described_class.format_rut("121485141", :dash_only)).to eq "12148514-1"
        expect(described_class.format_rut("125141", :dash_only)).to eq "12514-1"
      end
    end
    context "when normalized format is given" do
      it "returns the rut value without dots and dash" do
        expect(described_class.format_rut("1285389", :normalized)).to eq "1285389"
        expect(described_class.format_rut("121485141", :normalized)).to eq "121485141"
        expect(described_class.format_rut("12.148.514-1", :normalized)).to eq "121485141"
      end
    end
  end

  describe "valid_rut?" do
    context "when given a valid rut" do
      it "returns true" do
        expect(described_class.valid_rut?("12.148.514-1")).to eq true
        expect(described_class.valid_rut?("23.379.716-2")).to eq true
        expect(described_class.valid_rut?("18.486.758-3")).to eq true
      end
    end
    context "when given a invalid rut" do
      it "returns false" do
        expect(described_class.valid_rut?("14.001.723-8")).to eq false
        expect(described_class.valid_rut?("14.175.644-4")).to eq false
      end
    end
  end

  describe "stringify_rut" do
    it "returns the rut value as a string" do
      expect(described_class.stringify_rut(12_148_514)).to eq "12148514"
      expect(described_class.stringify_rut("12.148.514-1")).to eq "12.148.514-1"
      expect(described_class.stringify_rut(121_485_141)).to eq "121485141"
    end
    it "returns nil if the rut value is not valid" do
      expect(described_class.stringify_rut([])).to eq nil
      expect(described_class.stringify_rut(["1234"])).to eq nil
    end
  end
end
