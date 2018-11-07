module ActivePreview
  module Previewing
    extend ActiveSupport::Concern

    def preview(params)
      Builder.build(model: self, params: params)
    end
  end
end
