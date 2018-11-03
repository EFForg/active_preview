module ActivePreview
  module Generators
    class PreviewGenerator < Rails::Generators::Base
      desc 'Creates a Preview class for the given model and its associated '\
           'models'
      class_option :model, type: :string
      def create_preview
        model = options[:model].downcase
        empty_directory 'app/previews'
        create_file "app/previews/#{model}_preview.rb",
                    "class #{model.capitalize}Preview < ActivePreview::Preview"\
                    "\nend\n"
      end
    end
  end
end
