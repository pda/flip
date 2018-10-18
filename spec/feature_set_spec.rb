require "spec_helper"

class NullStrategy < Flip::AbstractStrategy
  def status(d); nil; end
end

class TrueStrategy < Flip::AbstractStrategy
  def status(d); true; end
end

describe Flip::FeatureSet do
  describe ".instance" do
    it "returns a singleton instance" do
      expect(Flip::FeatureSet.instance).to equal(Flip::FeatureSet.instance)
    end
    it "can be reset" do
      instance_before_reset = Flip::FeatureSet.instance
      Flip::FeatureSet.reset
      expect(Flip::FeatureSet.instance).to_not equal(instance_before_reset)
    end
    it "can be reset multiple times without error" do
      2.times { Flip::FeatureSet.reset }
    end
  end

  describe "#on?(:feature)" do
    let(:feature_set) do
      feature_set = Flip::FeatureSet.new
      feature_set << Flip::Definition.new(:feature)
      strategies.each { |s| feature_set.add_strategy(s) }
      feature_set
    end
    subject { feature_set.on?(:feature) }

    context "null strategy falling back on default values" do
      let(:strategies) { [NullStrategy] }
      before { feature_set.default = default if defined?(default) }

      context "default" do
        it { should be false }
      end
      context "true" do
        let(:default) { true }
        it { should be true }
      end
      context "proc returning true" do
        let(:default) { proc { true } }
        it { should be true }
      end
      context "proc returning false" do
        let(:default) { proc { false } }
        it { should be false }
      end
    end

    context "null strategy falling back to always-true strategy" do
      let(:strategies) { [NullStrategy, TrueStrategy] }
      it { should be true }
    end

    context "always-true strategy taking priority over null strategy" do
      let(:strategies) { [TrueStrategy, NullStrategy] }
      it do
        expect(feature_set.strategy('null')).to receive(:status).never
        should be true
      end
    end
  end
end
