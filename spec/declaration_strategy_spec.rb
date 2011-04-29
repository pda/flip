require "spec_helper"

describe Flip::DeclarationStrategy do

  def definition(default)
    Flip::Definition.new :feature, default: default
  end

  describe "#knows?" do
    specify "definition without default should be false" do
      subject.knows?(Flip::Definition.new :feature).should be_false
    end
    specify " should be true" do
      subject.knows?(definition(true)).should be_true
    end
  end

  describe "#on? for Flip::Definition with default of" do
    specify "true" do
      subject.on?(definition(true)).should be_true
    end
    specify "false" do
      subject.on?(definition(false)).should be_false
    end
    specify "proc returning true" do
      subject.on?(definition(proc { true })).should be_true
    end
    specify "proc returning false" do
      subject.on?(definition(proc { false })).should be_false
    end
  end

end
