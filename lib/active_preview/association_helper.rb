module AssociationHelper
  def association_from_key(key)
    key.to_s.split("_").tap { |arr| arr.delete("attributes") }.join("_")
  end

  def associations(klass)
    klass.reflect_on_all_associations.map { |a| a.name.to_s }
  end

  def class_of_association(base_class:, key: nil, association: nil)
    association = association_from_key(key) if key
    klass.reflect_on_association(association).klass
  end

  # Used to properly set parent in has_many previews
  def association_inverse(parent_class:, child_class:)
    parent = parent_class.to_s.downcase
    set = associations(child_class)
    return parent if set.include? parent
    set.each do |a|
      next unless singular? a
      if class_of_association(klass: child_class,
                              association: a) == parent_class
        return a
      end
    end
  end

  def singular?(name)
    name.singularize == name
  end
end
