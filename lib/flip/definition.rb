class Flip::Definition

  attr_accessor :key
  attr_accessor :options

  def initialize(key, options = {})
    @key = key
    @options = options.reverse_merge \
      description: key.to_s.humanize + "."
  end

  alias :name :key
  alias :to_s :key

  def description
    options[:description]
  end

end
