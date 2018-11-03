require 'active_preview/override_persistence'

module ActivePreview
  class Preview < SimpleDelegator
    include OverridePersistence
    include AssociationHelper

    def initialize(record)
      redefine_associations(record)
      super(record)
    end

    def original
      __getobj__
    end

    # ~ used in place of association names
    SINGULAR = %w(create_~ create_~! reload_~)
    COLLECTION = %w(~_id ~_id= ~<<)

    private

    def redefine_associations(record)
      associations(record.class).each do |a|
        next if respond_to? a # avoid redefining methods
        methods = singular?(a) ? SINGULAR : COLLECTION
        methods.each do |method|
          self.class.send(:define_method, method.gsub('~', a)) { }
        end
        self.class.send(:attr_accessor, a)
      end
    end
  end
end
