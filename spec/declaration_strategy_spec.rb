require "spec_helper"

describe Flip::DeclarationStrategy do

  def definition(default)
    Flip::Definition.new :feature, default: default
  end

  describe "#knows?" do
    it "does not know definition with no default specified" do
      subject.knows?(Flip::Definition.new :feature).should be false
    end
    it "does not know definition with default of nil" do
      subject.knows?(definition(nil)).should be false
    end
    it "knows definition with default set to true" do
      subject.knows?(definition(true)).should be true
    end
    it "knows definition with default set to false" do
      subject.knows?(definition(false)).should be true
    end
  end

  describe "#on? for Flip::Definition" do
    subject { Flip::DeclarationStrategy.new.on? definition(default) }
    [
      { default: true, result: true },
      { default: false, result: false },
      { default: proc { true }, result: true, name: "proc returning true" },
      { default: proc { false }, result: false, name: "proc returning false" },
    ].each do |parameters|
      context "with default of #{parameters[:name] || parameters[:default]}" do
        let(:default) { parameters[:default] }
        it { should == parameters[:result] }
      end
    end
  end

end
