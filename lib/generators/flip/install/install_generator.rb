class Flip::InstallGenerator < Rails::Generators::Base

  def invoke_generators
    %w{ initializer migration routes }.each do |name|
      generate "flip:#{name}"
    end
  end

end
