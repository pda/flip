require "rails/generators/active_record/migration"

class Flip::MigrationGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path("../templates", __FILE__)

  def create_migration_file
    migration_template "create_features.rb", "db/migrate/create_features.rb"
  end

  # Stubbed in railties/lib/rails/generators/migration.rb
  #
  # This implementation a simplified version of:
  #   activerecord/lib/rails/generators/active_record/migration.rb
  #
  # See: http://www.ruby-forum.com/topic/203205
  def self.next_migration_number(dirname)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

end
