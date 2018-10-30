class Pet < ApplicationRecord
  include ActivePreview::Previewing

  belongs_to :person
end
