require "spec_helper"

class ControllerWithoutCookieStrategy; end
class ControllerWithCookieStrategy
  def self.around_filter(_); end
  def cookies; []; end
  include Flip::CookieStrategy::Loader
end

describe Flip::CookieStrategy do

  let(:cookies) do
    { strategy.cookie_name(:one) => "true",
      strategy.cookie_name(:two) => "false" }
  end
  let(:strategy) do
    Flip::CookieStrategy.new.tap do |s|
      s.stub(:cookies) { cookies }
    end
  end

  its(:description) { should be_present }
  it { should be_switchable }

  describe "cookie interrogration" do
    context "enabled feature" do
      specify "#knows? is true" do
        strategy.knows?(:one).should be_true
      end
      specify "#on? is true" do
        strategy.on?(:one).should be_true
      end
    end
    context "disabled feature" do
      specify "#knows? is true" do
        strategy.knows?(:two).should be_true
      end
      specify "#on? is false" do
        strategy.on?(:two).should be_false
      end
    end
    context "feature with no cookie present" do
      specify "#knows? is false" do
        strategy.knows?(:three).should be_false
      end
      specify "#on? is false" do
        strategy.on?(:three).should be_false
      end
    end
  end

  describe "cookie manipulation" do
    it "can switch known features on" do
      strategy.switch! :one, true
      strategy.on?(:one).should be_true
    end
    it "can switch unknown features on" do
      strategy.switch! :three, true
      strategy.on?(:three).should be_true
    end
    it "can switch features off" do
      strategy.switch! :two, false
      strategy.on?(:two).should be_false
    end
    it "can delete knowledge of a feature" do
      strategy.delete! :one
      strategy.on?(:one).should be_false
      strategy.knows?(:one).should be_false
    end
  end

end

describe Flip::CookieStrategy::Loader do

  it "adds around_filter when included in controller" do
    ControllerWithoutCookieStrategy.tap do |klass|
      klass.should_receive(:around_filter).with(:cookie_feature_strategy)
      klass.send :include, Flip::CookieStrategy::Loader
    end
  end

  describe "#cookie_feature_strategy as around_filter" do

    let(:strategy) { Flip::CookieStrategy.new }
    let(:controller) { ControllerWithCookieStrategy.new }

    it "yields to block" do
      run = false
      ControllerWithCookieStrategy.new.cookie_feature_strategy { run = true }
      run.should be_true
    end

    it "passes controller cookies to Flip::CookieStrategy" do
      controller.should_receive(:cookies).and_return(strategy.cookie_name(:test) => "true")
      results = []
      controller.cookie_feature_strategy {
        results << strategy.on?(:test)
        results << strategy.on?(:different)
      }
      results.should == [ true, false ]
    end

  end
end
