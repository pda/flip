require "spec_helper"

describe Flip::DatabaseStrategy do

  let(:definition) { double("definition").tap{ |d| d.stub(:key) { :one } } }
  let(:strategy) { Flip::DatabaseStrategy.new(model_klass) }
  let(:model_klass) do
    Class.new do
      include Flip::Declarable
      feature :one
      feature :two, description: "Second one."
      feature :three, default: true
    end
  end
  let(:enabled_record) { model_klass.new.tap { |m| m.stub(:on?) { true } } }
  let(:disabled_record) { model_klass.new.tap { |m| m.stub(:on?) { false } } }

  subject { strategy }

  its(:switchable?) { should be_true }
  its(:description) { should be_present }

  describe "#knows?" do
    it "does not know features that cannot be found" do
      model_klass.stub(:find_by_key) { nil }
      strategy.knows?(definition).should be_false
    end
    it "knows features that can be found" do
      model_klass.stub(:find_by_key) { disabled_record }
      strategy.knows?(definition).should be_true
    end
  end

  describe "#on?" do
    it "is true for an enabled record from the database" do
      model_klass.stub(:find_by_key) { enabled_record }
      strategy.on?(definition).should be_true
    end
    it "is false for a disabled record from the database" do
      model_klass.stub(:find_by_key) { disabled_record }
      strategy.on?(definition).should be_false
    end
  end

  describe "#switch!" do
    it "can switch a feature on" do
      model_klass.should_receive(:find_or_initialize_by_key).with(:one).and_return(disabled_record)
      disabled_record.should_receive(:update_attributes!).with(on: true)
      strategy.switch! :one, true
    end
    it "can switch a feature off" do
      model_klass.should_receive(:find_or_initialize_by_key).with(:one).and_return(enabled_record)
      enabled_record.should_receive(:update_attributes!).with(on: false)
      strategy.switch! :one, false
    end
  end

  describe "#delete!" do
    it "can delete a feature record" do
      model_klass.should_receive(:find_by_key).with(:one).and_return(enabled_record)
      enabled_record.should_receive(:try).with(:destroy)
      strategy.delete! :one
    end
  end

end
