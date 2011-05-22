require "spec_helper"

describe Flip do

  before(:all) do
    Class.new do
      extend Flip::Declarable
      strategy Flip::DeclarationStrategy
      default false
      feature :one, default: true
      feature :two, default: false
    end
  end

  after(:all) do
    Flip.reset
  end

  describe ".on?" do
    it "returns true for enabled features" do
      Flip.on?(:one).should be_true
    end
    it "returns false for disabled features" do
      Flip.on?(:two).should be_false
    end
  end

  describe "dynamic predicate methods" do
    its(:one?) { should be_true }
    its(:two?) { should be_false }
  end

end
