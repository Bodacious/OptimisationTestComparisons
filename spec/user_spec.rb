require "spec_helper"


describe User do

  before :all do
    User.results = {
      "A" => 5.0,
      "B" => 8.512,
      "C" => 11.2,
      "D" => 0.0,
      "E" => 100.0,
    }
  end

  describe "::total_for_variant" do

    before do
      2.times { User.create(variant: "A", conversion: true) }
      3.times { User.create(variant: "A", conversion: false) }
      3.times { User.create(variant: "B", conversion: false) }
    end

    it "returns the total number of results for a given variant" do
      expect(User.total_for_variant('A')).to eql(5)
    end

  end

  describe "::conversions_for_variant" do

    before do
      2.times { User.create(variant: "A", conversion: true) }
      3.times { User.create(variant: "A", conversion: false) }
      3.times { User.create(variant: "B", conversion: false) }
    end

    it "returns the total number of conversions for a given variant" do
      expect(User.conversions_for_variant('A')).to eql(2)
    end

  end


  describe "::conversion_rate_for_variant" do

    before do
      2.times { User.create(variant: "A", conversion: true) }
      3.times { User.create(variant: "A", conversion: false) }
    end

    context "when there are results" do
      it "returns the percentage of users who converted" do
        expect(User.conversion_rate_for_variant("A")).to eql(40.0)
      end
    end

    context "when there are no results" do
      it "returns zero" do
        expect(User.conversion_rate_for_variant("ZZZ")).to eql(0.0)
      end
    end
  end

  describe "perform_test" do

    before do
      @user = User.new(variant: "A")
    end

    it "raises an exception if variant not set" do
      expect { subject.perform_test }.to raise_error(StandardError)
    end

    it "saves the record" do
      @user.perform_test
      expect(@user).to be_persisted
    end

    it "stores the conversion value" do
      @user.perform_test
      expect(@user.conversion).not_to be_nil
    end

  end

  describe "conversion?" do

    it "calculates the conversion based on the RESULTS percentages" do
      @user = User.new
      @user.variant = "D"
      @user.perform_test
      expect(@user).not_to be_conversion

      @user.variant = "E"
      @user.perform_test
      expect(@user).to be_conversion
    end

  end

end