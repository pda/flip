require "spec_helper"

class TestableFlipModel
  include Flip::Declarable

  strategy Flip::DeclarationStrategy
  default false

  feature :one
  feature :two, description: "Second one."
  feature :three, default: true
end

describe Flip::Declarable do

  subject { TestableFlipModel }

  context "with default set to false" do
    describe "dynamic predicate methods" do
      its(:one?) { should be_false }
      its(:two?) { should be_false }
      its(:three?) { should be_true }
    end
    describe "the .on? class method" do
      it { should_not be_on(:one) }
      it { should_not be_on(:two) }
      it { should be_on(:three) }
    end
  end

  context "with default set to false" do
    before(:all) { subject.send(:default, true) }
    describe "dynamic predicate methods" do
      its(:one?) { should be_true }
      its(:two?) { should be_true }
      its(:three?) { should be_true }
    end
    describe "the .on? class method" do
      it { should be_on(:one) }
      it { should be_on(:two) }
      it { should be_on(:three) }
    end
  end

end
