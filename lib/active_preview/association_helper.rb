module AssociationHelper
  def association_from_key(key)
    key.to_s.split("_").tap { |arr| arr.delete("attributes") }.join("_")
  end

  def associations(klass)
    klass.reflect_on_all_associations.map { |a| a.name.to_s }
  end

  def association_class(klass:, key:)
    klass.reflect_on_association(association_from_key(key)).klass
  end

  def singular?(name)
    name.singularize == name
  end
end
