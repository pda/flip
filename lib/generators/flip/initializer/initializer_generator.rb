class Flip::InitializerGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_initializer_file
    copy_file "features.rb", "config/initializers/features.rb"
  end

end
