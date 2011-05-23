require "spec_helper"

class NullStrategy < Flip::AbstractStrategy
  def knows?(d); false; end
end

class TrueStrategy < Flip::AbstractStrategy
  def knows?(d); true; end
  def on?(d); true; end
end

describe Flip::FeatureSet do

  let :feature_set_with_null_strategy do
    Flip::FeatureSet.new.tap do |s|
      s << Flip::Definition.new(:feature)
      s.add_strategy NullStrategy
    end
  end

  let :feature_set_with_null_then_true_strategies do
    feature_set_with_null_strategy.tap do |s|
      s.add_strategy TrueStrategy
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
    subject { feature_set_with_null_strategy }
    it "defaults to false" do
      subject.on?(:feature).should be_false
    end
    it "can default to true" do
      subject.default = true
      subject.on?(:feature).should be_true
    end
    it "accepts a proc returning true" do
      subject.default = proc { true }
      subject.on?(:feature).should be_true
    end
    it "accepts a proc returning false" do
      subject.default = proc { false }
      subject.on?(:feature).should be_false
    end
  end

  describe "feature set with null strategy then always-true strategy" do
    subject { feature_set_with_null_then_true_strategies }
    it "returns true due to second strategy" do
      subject.on?(:feature).should be_true
    end
  end

end
