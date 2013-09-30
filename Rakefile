require 'bundler'
Bundler::GemHelper.install_tasks

desc "Run all tests"
task :default => :spec

desc "Run specs"
task :spec do
  command = "bundle exec rspec --color --format documentation spec/*_spec.rb"
  system(command) || raise("specs returned non-zero code")
end
