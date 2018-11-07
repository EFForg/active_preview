module ActivePreview
  class Builder
    include AssociationHelper

    def self.build(**args)
      new(**args).build
    end

    def initialize(model:, params: {}, parent: nil)
      @model = model
      @params = params
      @klass = model.class
      @parent = parent
    end

    def build
      build_preview_object
      update_associations
      associate_parent
      load_associations
      return preview
    end

    private

    attr_reader :model, :params, :klass, :preview, :updated_associations,
      :parent

    def build_preview_object
      @preview ||= preview_class.new(klass.new(model.attributes.merge(params)))
    end

    def preview_class
      "#{klass}Preview".constantize
    end

    def update_associations
      @updated_associations ||= child_params_keys.map do |params_key|
        association_from_key(params_key).tap do |a|
          next if preview.ignored_associations.include? a
          preview.send("#{a}=", build_children(params_key, a))
        end
      end
    end

    def child_params_keys
      @child_params_keys ||= params.map do |k, _|
        a = association_from_key(k)
        # TODO: singular associations
        k if associations(klass).include?(a) && !singular?(a)
      end.compact
    end

    def build_children(params_key, association)
      child_params = params[params_key].to_h.values
                                       .sort! { |a, b| a["id"] <=> b["id"] }
      saved = model.send(association).order(:id)
      child_klass = class_of_association(base_class: klass,
                                         association: association)
      BatchBuilder.build(klass: child_klass, saved_models: saved,
                         params: child_params, parent: preview)
    end

    def associate_parent
      return unless parent
      association = association_inverse(parent_class: parent.model_object.class,
                                        child_class: klass)
      preview.send("#{association}=", parent)
      @updated_associations << association
    end

    def load_associations
      associations(klass).each do |a|
        next if updated_associations.include? a 
        next if preview.ignored_associations.include? a
        saved = [*model.send(a)]
        next if saved.empty?
        to_assign = BatchBuilder.build(klass: saved.first.class,
                                       saved_models: saved, parent: preview)
        to_assign = to_assign.first if singular? a
        preview.send("#{a}=", to_assign)
      end
    end
  end
end
