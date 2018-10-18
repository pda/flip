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
    subject { Flip.on?(key) }
    it "returns true for enabled features" do
      expect(Flip.on?(:one)).to be true
    end
    it "returns false for disabled features" do
      expect(Flip.on?(:two)).to be false
    end
  end

  describe "dynamic predicate methods" do
    its(:one?) { should be true }
    its(:two?) { should be false }
  end

end
