require "spec_helper"

describe Flip::DeclarationStrategy do
  describe "#status" do
    let(:definition) { Flip::Definition.new(:feature, opts) }
    subject { Flip::DeclarationStrategy.new.status(definition) }

    context "no default specified" do
      let(:opts) { Hash.new }
      it { should be_nil }
    end
    context "default of nil" do
      let(:opts) { { default: nil } }
      it { should be_nil }
    end
    context "default set to true" do
      let(:opts) { { default: true } }
      it { should be true }
    end
    context "default set to false" do
      let(:opts) { { default: false } }
      it { should be false }
    end
    context "default proc returning true" do
      let(:opts) { { default: proc { true } } }
      it { should be true }
    end
    context "default proc returning false" do
      let(:opts) { { default: proc { false } } }
      it { should be false }
    end
  end
end
