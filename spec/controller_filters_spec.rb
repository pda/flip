require "spec_helper"

class ControllerWithFlipFilters
  include Flip::ControllerFilters
end

describe ControllerWithFlipFilters do

  describe ".require_feature" do

    it "adds before_filter without options" do
      ControllerWithFlipFilters.tap do |klass|
        klass.should_receive(:before_filter).with({})
        klass.send(:require_feature, :testable)
      end
    end

    it "adds before_filter with options" do
      ControllerWithFlipFilters.tap do |klass|
        klass.should_receive(:before_filter).with({ only: [ :show ] })
        klass.send(:require_feature, :testable, only: [ :show ])
      end
    end

  end

end
