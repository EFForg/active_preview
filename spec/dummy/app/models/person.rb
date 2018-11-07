class Person < ApplicationRecord
  include ActivePreview::Previewing

  has_many :pets
  accepts_nested_attributes_for :pets
  has_many :accounts
  accepts_nested_attributes_for :accounts
  has_many :roles
  accepts_nested_attributes_for :roles
end
