# Access to feature-flipping configuration.
module FlipHelper

  # Whether the given feature is switched on
  def feature?(key)
    Flip.on? key
  end

end
