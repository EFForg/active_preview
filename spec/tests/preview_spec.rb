require 'rails_helper'

RSpec.describe "Preview delegator" do

  it 'overrides save' do
    person = Person.create(name: 'Name', age: 25)
    preview = PersonPreview.new(person)
    preview.name = 'New Name'
    preview.save
    expect(person.reload.name).to eq('Name')
  end

  it 'overrides association autosaving' do
    person = Person.create(name: 'Name', age: 25)
    Pet.create(name: 'Pet Name', person: person)
    preview = PersonPreview.new(person)
    preview.pets = []
    expect(person.reload.pets).not_to be_empty
  end
end
