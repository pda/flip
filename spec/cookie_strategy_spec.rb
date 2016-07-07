require "spec_helper"
require "action_dispatch"
require "rack"

class ControllerWithoutCookieStrategy; end
class ControllerWithCookieStrategy
  def self.before_filter(_); end
  def self.after_filter(_); end
  def cookies; cookie_jar; end
  include Flip::CookieStrategy::Loader
end

def cookie_jar
  env = Rack::MockRequest.env_for("/example")
  request = ActionDispatch::TestRequest.new(env)
  ActionDispatch::Cookies::CookieJar.build(request)
end

describe Flip::CookieStrategy do

  let(:cookies) do
    cookie_jar.tap do |jar|
      jar[strategy.cookie_name(:one)] = "true"
      jar[strategy.cookie_name(:two)] = "false"
    end
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
        strategy.knows?(:one).should be true
      end
      specify "#on? is true" do
        strategy.on?(:one).should be true
      end
    end
    context "disabled feature" do
      specify "#knows? is true" do
        strategy.knows?(:two).should be true
      end
      specify "#on? is false" do
        strategy.on?(:two).should be false
      end
    end
    context "feature with no cookie present" do
      specify "#knows? is false" do
        strategy.knows?(:three).should be false
      end
      specify "#on? is false" do
        strategy.on?(:three).should be false
      end
    end
  end

  describe "cookie manipulation" do
    it "can switch known features on" do
      strategy.switch! :one, true
      strategy.on?(:one).should be true
    end
    it "can switch unknown features on" do
      strategy.switch! :three, true
      strategy.on?(:three).should be true
    end
    it "can switch features off" do
      strategy.switch! :two, false
      strategy.on?(:two).should be false
    end
    it "can delete knowledge of a feature" do
      strategy.delete! :one
      strategy.on?(:one).should be false
      strategy.knows?(:one).should be false
    end
  end

end

describe Flip::CookieStrategy::Loader do

  it "adds filters when included in controller" do
    ControllerWithoutCookieStrategy.tap do |klass|
      klass.should_receive(:before_filter).with(:flip_cookie_strategy_before)
      klass.should_receive(:after_filter).with(:flip_cookie_strategy_after)
      klass.send :include, Flip::CookieStrategy::Loader
    end
  end

  describe "filter methods" do
    let(:strategy) { Flip::CookieStrategy.new }
    let(:controller) { ControllerWithCookieStrategy.new }
    describe "#flip_cookie_strategy_before" do
      it "passes controller cookies to CookieStrategy" do
        controller.should_receive(:cookies).and_return(strategy.cookie_name(:test) => "true")
        expect {
          controller.flip_cookie_strategy_before
        }.to change {
          [ strategy.knows?(:test), strategy.on?(:test) ]
        }.from([false, false]).to([true, true])
      end
    end
    describe "#flip_cookie_strategy_after" do
      before do
        Flip::CookieStrategy.cookies = { strategy.cookie_name(:test) => "true" }
      end
      it "passes controller cookies to CookieStrategy" do
        expect {
          controller.flip_cookie_strategy_after
        }.to change {
          [ strategy.knows?(:test), strategy.on?(:test) ]
        }.from([true, true]).to([false, false])
      end
    end
  end

end
