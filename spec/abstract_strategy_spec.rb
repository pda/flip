require "spec_helper"

# Perhaps this is silly, but it provides some
# coverage to an important base class.
describe Flip::AbstractStrategy do
  let(:subclass) do
    Class.new(Flip::AbstractStrategy) do
      description "A test subclass"
      def self.name; "SubclassTestStrategy"; end
    end
  end
  subject { subclass.new }

  its(:name) { should eq "subclass_test" }
  its(:description) { should eq "A test subclass" }
  it { should_not be_switchable }

end
