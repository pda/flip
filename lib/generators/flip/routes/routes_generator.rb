class Flip::RoutesGenerator < Rails::Generators::Base

  def add_route
    route %{mount Flip::Engine => "/flip"}
  end

end
