require "spec_helper"

class NullStrategy < Flip::AbstractStrategy
  def status(d); nil; end
end

class TrueStrategy < Flip::AbstractStrategy
  def status(d); true; end
end

describe Flip::FeatureSet do
  subject(:feature_set) do
    Flip::FeatureSet.new.tap do |fs|
      fs << Flip::Definition.new(:feature)
      strategies.each { |s| fs.add_strategy(s) }
    end
  end

  describe ".instance" do
    it "returns a singleton instance" do
      Flip::FeatureSet.instance.should equal(Flip::FeatureSet.instance)
    end
    it "can be reset" do
      instance_before_reset = Flip::FeatureSet.instance
      Flip::FeatureSet.reset
      Flip::FeatureSet.instance.should_not equal(instance_before_reset)
    end
    it "can be reset multiple times without error" do
      2.times { Flip::FeatureSet.reset }
    end
  end

  describe "#default= and #on? with null strategy" do
    let(:strategies) { [NullStrategy] }
    it "defaults to false" do
      subject.on?(:feature).should be false
    end
    it "can default to true" do
      subject.default = true
      subject.on?(:feature).should be true
    end
    it "accepts a proc returning true" do
      subject.default = proc { true }
      subject.on?(:feature).should be true
    end
    it "accepts a proc returning false" do
      subject.default = proc { false }
      subject.on?(:feature).should be false
    end
  end

  describe "feature set with null strategy then always-true strategy" do
    let(:strategies) { [NullStrategy, TrueStrategy] }
    it "returns true due to second strategy" do
      subject.on?(:feature).should be true
    end
  end

  describe "feature set with always-true strategy then null strategy" do
    let(:strategies) { [TrueStrategy, NullStrategy] }
    it "returns true without evaluating null strategy" do
      feature_set.strategy('null').should_receive(:status).never
      subject.on?(:feature).should be true
    end
  end

end
