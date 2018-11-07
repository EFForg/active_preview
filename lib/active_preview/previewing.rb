module ActivePreview
  module Previewing
    extend ActiveSupport::Concern

    def preview(params)
      PreviewBuilder.build(model: self, params: params)
    end
  end
end
