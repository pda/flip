# ActiveSupport dependencies.
%w{
  concern
  inflector
  core_ext/hash/reverse_merge
  core_ext/object/blank
}.each { |name| require "active_support/#{name}" }

# Flip files.
%w{
  abstract_strategy
  cacheable
  controller_filters
  cookie_strategy
  database_strategy
  declarable
  declaration_strategy
  definition
  facade
  feature_set
  forbidden
}.each { |name| require "flip/#{name}" }

require "flip/engine" if defined?(Rails)

module Flip
  extend Facade
end
