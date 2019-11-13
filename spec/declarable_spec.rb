require "spec_helper"

describe Flip::Declarable do

  let!(:model_class) do
    Class.new do
      extend Flip::Declarable

      strategy Flip::DeclarationStrategy
      default false

      feature :one
      feature :two, description: "Second one."
      feature :three, default: true
    end
  end

  subject { Flip::FeatureSet.instance }

  describe "the .on? class method" do
    context "with default set to false" do
      it { should_not be_on(:one) }
      it { should be_on(:three) }
    end

    context "with default set to true" do
      before { model_class.send(:default, true) }
      it { should be_on(:one) }
      it { should be_on(:three) }
    end
  end

  describe "the .strategy class method" do
    let!(:model_class) do
      Class.new do
        extend Flip::Declarable
      end
    end

    it "passes the class it's on" do
      expect(Flip::DeclarationStrategy).to receive(:new)
        .with(model_class)
        .and_call_original
      model_class.strategy Flip::DeclarationStrategy
    end
  end
end
