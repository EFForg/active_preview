class Person < ApplicationRecord
  include ActivePreview::Previewing

  has_many :pets
  accepts_nested_attributes_for :pets
end
