require "spec_helper"

describe Flip::DatabaseStrategy do

  let(:definition) { double("definition", key: "one") }
  let(:strategy) { Flip::DatabaseStrategy.new(model_klass) }
  let(:model_klass) do
    Class.new do
      extend Flip::Declarable
      feature :one
      feature :two, description: "Second one."
      feature :three, default: true
    end
  end
  let(:enabled_record) { model_klass.new.tap { |m| m.stub(:enabled?) { true } } }
  let(:disabled_record) { model_klass.new.tap { |m| m.stub(:enabled?) { false } } }

  subject { strategy }

  its(:switchable?) { should be_true }
  its(:description) { should be_present }

  let(:db_result) { [] }
  before do
    allow(model_klass).to(receive(:where).with(key: "one").and_return(db_result))
  end

  describe "#knows?" do
    context "for unknown key" do
      it "returns true" do
        expect(strategy.knows?(definition)).to eq(false)
      end
    end
    context "for known key" do
      let(:db_result) { [disabled_record] }
      it "returns false" do
        expect(strategy.knows?(definition)).to eq(true)
      end
    end
  end

  describe "#on?" do
    context "for an enabled record" do
      let(:db_result) { [enabled_record] }
      it "returns true" do
        expect(strategy.on?(definition)).to eq(true)
      end
    end
    context "for a disabled record" do
      let(:db_result) { [disabled_record] }
      it "returns true" do
        expect(strategy.on?(definition)).to eq(false)
      end
    end
  end

  describe "#switch!" do
    it "can switch a feature on" do
      expect(db_result).to receive(:first_or_initialize).and_return(disabled_record)
      disabled_record.should_receive(:update_attributes!).with(enabled: true)
      strategy.switch! :one, true
    end
    it "can switch a feature off" do
      expect(db_result).to receive(:first_or_initialize).and_return(enabled_record)
      enabled_record.should_receive(:update_attributes!).with(enabled: false)
      strategy.switch! :one, false
    end
  end

  describe "#delete!" do
    let(:db_result) { [enabled_record] }
    it "can delete a feature record" do
      enabled_record.should_receive(:try).with(:destroy)
      strategy.delete! :one
    end
  end

end
