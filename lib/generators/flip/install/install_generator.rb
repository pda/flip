class Flip::InstallGenerator < Rails::Generators::Base

  def invoke_generators
    %w{ model migration routes }.each do |name|
      generate "flip:#{name}"
    end
  end

end
