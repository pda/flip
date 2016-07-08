require "spec_helper"

class ControllerWithFlipFilters
  include Flip::ControllerFilters
end

describe ControllerWithFlipFilters do

  describe ".require_feature" do

    it "adds before_action without options" do
      ControllerWithFlipFilters.tap do |klass|
        klass.should_receive(:before_action).with({})
        klass.send(:require_feature, :testable)
      end
    end

    it "adds before_action with options" do
      ControllerWithFlipFilters.tap do |klass|
        klass.should_receive(:before_action).with({ only: [ :show ] })
        klass.send(:require_feature, :testable, only: [ :show ])
      end
    end

  end

end
