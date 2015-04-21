require "spec_helper"

class ControllerWithoutSessionStrategy; end
class ControllerWithSessionStrategy
  def self.before_filter(_); end
  def self.after_filter(_); end
  def session; []; end
  include Flip::SessionStrategy::Loader
end

describe Flip::SessionStrategy do

  let(:session) do
    { strategy.session_name(:one) => "true",
      strategy.session_name(:two) => "false" }
  end
  let(:strategy) do
    Flip::SessionStrategy.new.tap do |s|
      s.stub(:session) { session }
    end
  end

  its(:description) { should be_present }
  it { should be_switchable }
  describe "session interrogration" do
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
    context "feature with no session present" do
      specify "#knows? is false" do
        strategy.knows?(:three).should be false
      end
      specify "#on? is false" do
        strategy.on?(:three).should be false
      end
    end
  end

  describe "session manipulation" do
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

describe Flip::SessionStrategy::Loader do

  it "adds filters when included in controller" do
    ControllerWithoutSessionStrategy.tap do |klass|
      klass.should_receive(:before_filter).with(:flip_session_strategy_before)
      klass.should_receive(:after_filter).with(:flip_session_strategy_after)
      klass.send :include, Flip::SessionStrategy::Loader
    end
  end

  describe "filter methods" do
    let(:strategy) { Flip::SessionStrategy.new }
    let(:controller) { ControllerWithSessionStrategy.new }
    describe "#flip_session_strategy_before" do
      it "passes controller session to SessionStrategy" do
        controller.should_receive(:session).and_return(strategy.session_name(:test) => "true")
        expect {
          controller.flip_session_strategy_before
        }.to change {
          [ strategy.knows?(:test), strategy.on?(:test) ]
        }.from([false, false]).to([true, true])
      end
    end
    describe "#flip_session_strategy_after" do
      before do
        Flip::SessionStrategy.session = { strategy.session_name(:test) => "true" }
      end
      it "passes controller session to SessionStrategy" do
        expect {
          controller.flip_session_strategy_after
        }.to change {
          [ strategy.knows?(:test), strategy.on?(:test) ]
        }.from([true, true]).to([false, false])
      end
    end
  end
end
