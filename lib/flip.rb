%w{
  concern
  inflector
  core_ext/hash/reverse_merge
}.each { |name| require "active_support/#{name}" }

module Flip
end
