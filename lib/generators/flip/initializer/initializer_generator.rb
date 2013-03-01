class Flip::InitializerGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_initializer_file
    copy_file "feature.rb", "config/initializers/feature.rb"
  end

end
