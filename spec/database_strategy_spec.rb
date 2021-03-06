require "spec_helper"

describe Flip::DatabaseStrategy do
  let(:model_klass) do
    Class.new do
      extend Flip::Cacheable
      extend Flip::Declarable
      feature :one
      feature :two, description: "Second one."
      feature :three, default: true

      def self.all
        %w[one two three].map do |key|
          new(key, true)
        end
      end

      attr_reader :key

      def initialize(key, enabled)
        @key = key
        @enabled = enabled
      end

      def enabled?
        @enabled
      end
    end
  end

  subject(:strategy) { Flip::DatabaseStrategy.new(model_klass) }

  its(:switchable?) { should be true }
  its(:description) { should be_present }

  context "with a feature definition" do
    before do
      allow(model_klass).to(receive(:where).with(key: "one").once.and_return(db_result))
    end

    let(:definition) { double("definition", key: "one") }
    let(:enabled_record) { model_klass.new('enabled_feature', true) }
    let(:disabled_record) { model_klass.new('disabled_feature', false) }

    describe "#status" do
      subject { strategy.status(definition) }

      context "for unknown key" do
        let(:db_result) { [] }
        it { should be_nil }
      end
      context "for an enabled record" do
        let(:db_result) { [enabled_record] }
        it { should be true }
      end
      context "for a disabled record" do
        let(:db_result) { [disabled_record] }
        it { should be false }
      end

      describe "with feature cache" do
        before { model_klass.start_feature_cache }
        context "for an enabled record" do
          let(:db_result) { [enabled_record] }
          it { should be true }
        end
      end
    end

    describe "#switch!" do
      let(:db_result) { [] }
      it "can switch a feature on" do
        expect(db_result).to receive(:first_or_initialize).and_return(disabled_record)
        expect(disabled_record).to receive(:enabled=).with(true)
        expect(disabled_record).to receive(:save!)
        strategy.switch! :one, true
      end
      it "can switch a feature off" do
        expect(db_result).to receive(:first_or_initialize).and_return(enabled_record)
        expect(enabled_record).to receive(:enabled=).with(false)
        expect(enabled_record).to receive(:save!)
        strategy.switch! :one, false
      end
    end

    describe "#delete!" do
      let(:db_result) { [enabled_record] }
      it "can delete a feature record" do
        expect(enabled_record).to receive(:try).with(:destroy)
        strategy.delete! :one
      end
    end
  end

end
