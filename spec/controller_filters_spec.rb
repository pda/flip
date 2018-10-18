require "spec_helper"

class ControllerWithFlipFilters
  include Flip::ControllerFilters
end

describe ControllerWithFlipFilters do
  describe ".require_feature" do
    it "adds before_action without options" do
      expect(ControllerWithFlipFilters).to receive(:before_action).with({})
      ControllerWithFlipFilters.require_feature(:testable)
    end

    it "adds before_action with options" do
      expect(ControllerWithFlipFilters).to receive(:before_action).with(only: [:show])
      ControllerWithFlipFilters.require_feature(:testable, only: [:show])
    end
  end
end
