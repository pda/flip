require "spec_helper"
require "action_dispatch"

class ControllerWithoutCookieStrategy; end
class ControllerWithCookieStrategy
  def self.before_action(_); end
  def self.after_action(_); end
  def cookies; []; end
  include Flip::CookieStrategy::Loader
end

module MockRails
  class << self
    def cookie(hash)
      case ActiveSupport.version
      when Gem::Requirement.new("~> 4.0") then rails_4
      when Gem::Requirement.new("~> 5.0") then rails_5
      else raise NotImplementedError, "Rails #{ActiveSupport.version} not suported"
      end.update(hash)
    end

    private

    def rails_4
      ActionDispatch::Cookies::CookieJar.new(nil, "www.example.com", false)
    end

    def rails_5
      request_mock = Struct.new(:host, :ssl?).new("www.example.com", false)
      ActionDispatch::Cookies::CookieJar.new(request_mock)
    end
  end
end

describe Flip::CookieStrategy do
  let(:strategy) { Flip::CookieStrategy.new }
  let(:cookies) do
    MockRails.cookie(
      strategy.cookie_name(:one) => "true",
      strategy.cookie_name(:two) => "false",
    )
  end

  before do
    Flip::CookieStrategy.cookies = cookies
  end

  its(:description) { should be_present }
  it { should be_switchable }

  describe "cookie strategy status" do
    subject { strategy.status(definition) }

    context "enabled feature" do
      let(:definition) { :one }
      it { should be true }
    end
    context "disabled feature" do
      let(:definition) { :two }
      it { should be false }
    end
    context "feature with no cookie present" do
      let(:definition) { :three }
      it { should be_nil }
    end
  end

  describe "cookie manipulation" do
    it "can switch known features on" do
      strategy.switch! :one, true
      expect(strategy.status(:one)).to be true
    end
    it "can flip known features on for all subdomains" do
      strategy.switch! :two, true
      expect(strategy.status(:two)).to be true

      headers = Hash.new.tap { |h| cookies.write(h) }
      expect(headers["Set-Cookie"]).to eq "flip_two=true; domain=.example.com; path=/"
    end
    it "can switch unknown features on" do
      strategy.switch! :three, true
      expect(strategy.status(:three)).to be true
    end
    it "can switch features off" do
      strategy.switch! :two, false
      expect(strategy.status(:two)).to be false
    end
    it "can delete knowledge of a feature for all subdomains" do
      strategy.delete! :one
      expect(cookies).to be_deleted(strategy.cookie_name(:one), domain: :all)
      expect(strategy.status(:one)).to be_nil
    end
  end

end

describe Flip::CookieStrategy::Loader do

  it "adds filters when included in controller" do
    ControllerWithoutCookieStrategy.tap do |klass|
      expect(klass).to receive(:before_action).with(:flip_cookie_strategy_before)
      expect(klass).to receive(:after_action).with(:flip_cookie_strategy_after)
      klass.send :include, Flip::CookieStrategy::Loader
    end
  end

  describe "filter methods" do
    let(:strategy) { Flip::CookieStrategy.new }
    let(:controller) { ControllerWithCookieStrategy.new }
    describe "#flip_cookie_strategy_before" do
      it "passes controller cookies to CookieStrategy" do
        expect(controller).to receive(:cookies).and_return(strategy.cookie_name(:test) => "true")
        expect {
          controller.flip_cookie_strategy_before
        }.to change {
          strategy.status(:test)
        }.from(nil).to(true)
      end
    end
    describe "#flip_cookie_strategy_after" do
      before do
        Flip::CookieStrategy.cookies = MockRails.cookie(strategy.cookie_name(:test) => "true")
      end
      it "passes controller cookies to CookieStrategy" do
        expect {
          controller.flip_cookie_strategy_after
        }.to change {
          strategy.status(:test)
        }.from(true).to(nil)
      end
    end
  end

end
