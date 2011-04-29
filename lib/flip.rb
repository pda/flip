%w{
  concern
  inflector
  core_ext/hash/reverse_merge
}.each { |name| require "active_support/#{name}" }

%w{
  abstract_strategy
  controller_filters
  cookie_strategy
  database_strategy
  declarable
  declaration_strategy
  definition
  feature_set
}.each { |name| require "flip/#{name}" }

module Flip
end
