# Database backed system-wide
class Flip::DatabaseStrategy < Flip::AbstractStrategy

  def initialize(model_klass)
    @klass = model_klass
  end

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
    @klass.find_or_initialize_by_key(key).update_attributes! on: on
  end

  def delete! key
    @klass.find_by_key(key).try(:destroy)
  end

  private

  def feature(definition)
    @klass.find_by_key definition.key
  end

end
