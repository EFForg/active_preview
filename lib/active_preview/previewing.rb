module ActivePreview
  module Previewing
    extend ActiveSupport::Concern
    include AssociationHelper

    included do
      def self.collection_preview(saved, params)
        child_args(saved, params).map do |obj, attrs|
          if obj
            obj.preview(attrs)
          else
            self.new(attrs).preview
          end
        end
      end

      private

      def self.child_args(saved, child_attrs)
        if saved.size > child_attrs.size
          saved.zip(child_attrs)
        else
          child_attrs.zip(saved).map(&:reverse!)
        end
      end
    end

    # Returns an unsaved object with updated attributes, along with any
    # child objects and their updated attributes.
    # Note that the associations are not assigned, so parent.children will be
    # empty
    def preview(params)
      merged_object(params).tap do |p|
        child_keys(params).each do |params_key|
          association = association_from_key(params_key)
          next unless associations(self.class).include?(association)
          p.send("#{association}=", generate_children(params, params_key))
        end
      end
    end

    private

    def merged_object(new_attrs)
      preview_class.new(self.class.new(self.attributes.merge(new_attrs)))
    end

    def preview_class
      "#{self.class}Preview".constantize
    end

    def child_keys(hash)
      hash.map do |k, v|
        k if v.is_a?(ActionController::Parameters) || v.is_a?(Hash)
      end.compact
    end

    def generate_children(params, *params_keys)
      child_params = params.dig(*params_keys).to_h.values
        .sort! { |a, b| a["id"] <=> b["id"] }
      klass = association_class(klass: self.class, key: params_keys.last)
      saved = klass.where(id: child_params.map { |p| p["id"] }).order(:id)
      klass.collection_preview(saved, child_params)
    end
  end
end
