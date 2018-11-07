module ActivePreview
  class BatchBuilder
    def self.build(**args)
      new(**args).build
    end

    def initialize(klass:, saved_models:, params: nil, parent: nil)
      @klass = klass
      @saved_models = saved_models
      @params_set = params
      @parent = parent
    end

    def build
      objects_with_new_attrs.map do |obj, attrs|
        obj ||= klass.new
        attrs ||= {}
        Builder.build(model: obj, params: attrs, parent: parent)
      end
    end

    private

    attr_reader :klass, :saved_models, :params_set, :parent

    def objects_with_new_attrs
      return saved_models unless params_set
      if saved_models.size > params_set.size
        saved_models.zip(params_set)
      else
        params_set.zip(saved_models).map(&:reverse!)
      end
    end
  end
end
