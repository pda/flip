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
      before(:all) { model_class.send(:default, true) }
      it { should be_on(:one) }
      it { should be_on(:three) }
    end
  end

end
