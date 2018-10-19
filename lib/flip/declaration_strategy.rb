# Uses :default option passed to feature declaration.
# May be boolean or a Proc to be passed the definition.
module Flip
  class DeclarationStrategy < AbstractStrategy
    description "The default status declared with the feature."

    def status definition
      if !definition.options[:default].nil?
        default = definition.options[:default]
        default.is_a?(Proc) ? default.call(definition) : default
      end
    end

  end
end
