require 'active_preview/override_persistence'

class Preview < SimpleDelegator
  include OverridePersistence
  include AssociationHelper

  def original
    __getobj__
  end

  # ~ used in place of association names
  SINGULAR = %w(create_~ create_~! reload_~)
  COLLECTION = %w(~_id ~_id= ~<<)

  private

  def redefine_associations
    associations(__getobj__.class).each do |a|
      methods = singular?(a) ? SINGULAR : COLLECTION
      methods.each do |method| 
        self.class.send(:define_method, method.gsub('~', a)) { }
      end
      self.class.send(:attr_accessor, a)
    end
  end
end
