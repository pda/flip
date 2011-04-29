# Database backed system-wide
class Flip::DatabaseStrategy < Flip::AbstractStrategy

  def description
    "Database backed, applies to all users."
  end

  def knows? definition
    !!feature(definition)
  end

  def on? definition
    feature(definition).on?
  end

  def switchable?
    true
  end

  def switch! key, on
    Flip.find_or_initialize_by_key(key).update_attributes! on: on
  end

  def delete! key
    Flip.find_by_key(key).try(:destroy)
  end

  private

  def feature(definition)
    Flip.find_by_key definition.key
  end

end
