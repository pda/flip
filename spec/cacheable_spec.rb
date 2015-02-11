require "spec_helper"

describe Flip::Cacheable do

  subject(:model_class) do
    class Sample
      attr_accessor :key
    end

    Class.new do
      extend Flip::Declarable
      extend Flip::Cacheable

      strategy Flip::DeclarationStrategy
      default false

      feature :one
      feature :two, description: "Second one."
      feature :three, default: true

      def self.all
        list = []
        i = 65
        3.times do
          list << Sample.new
          list.last.key = i.chr()
          i += 1
        end
        list
      end
    end
  end

  describe "with feature cache" do
    context "initial context" do
      it { should respond_to(:use_feature_cache) }
      it { should respond_to(:clear_feature_cache) }
      it { should respond_to(:feature_cache) }
      specify { model_class.use_feature_cache.should be_nil }
    end

    context "after a cache clear" do
      before { model_class.clear_feature_cache }
      specify { model_class.use_feature_cache.should be_true }
      specify { model_class.feature_cache.map{ |f| f.key } == ['A', 'B', 'C']}
    end
  end

end
